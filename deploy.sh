#!/usr/bin/env sh

function remoteName() {
  basename $1
}

function herokuName() {
  echo $(remoteName $1) | rev | cut -f 2- -d '.' | rev
}

function herokuCreate() {
  heroku apps:create $(herokuName $1)
}

function herokuDelete() {
  heroku apps:destroy $(herokuName $1) --confirm $(herokuName $1)
}

function addPostgres() {
  heroku addons:create heroku-postgresql:hobby-basic --app $(herokuName $1)
}

function pushNMigrate() {
  git remote rm $(remoteName $1)
  git remote add $(remoteName $1) $1

  git push $(remoteName $1) master
  heroku run 'rake db:migrate' --app $(herokuName $1)
}

function downloadExport() {
  open http://$(herokuName $1).herokuapp.com/tests/export?name=$(herokuName $1)
}

function seedTests() {
  case $(herokuName $1) in
  "nb-uiwebview-native")
    ./heroku-reset.sh $(herokuName $1) uiwebview native suite
    ;;
  "nb-native-uiwebview")
    ./heroku-reset.sh $(herokuName $1) uiwebview webview suite
    ;;
  "nb-wkwebview-native")
    ./heroku-reset.sh $(herokuName $1) wkwebview native suite
    ;;
  "nb-native-wkwebview")
    ./heroku-reset.sh $(herokuName $1) wkwebview webview suite
    ;;
  "*")
    echo "no idea!"
    exit 1
  esac
}

read -r -d "\n" REMOTES << EOF
https://git.heroku.com/nb-uiwebview-native.git
https://git.heroku.com/nb-native-uiwebview.git
https://git.heroku.com/nb-wkwebview-native.git
https://git.heroku.com/nb-native-wkwebview.git
EOF

IFS="
"



for REMOTE in $REMOTES; do
  #herokuDelete $REMOTE
  #herokuCreate $REMOTE
  #addPostgres $REMOTE
  #pushNMigrate $REMOTE
  #seedTests $REMOTE

  downloadExport $REMOTE
done

exit 1

git remote add heroku git@heroku.com:nativebridge-benchmark.git

heroku maintenance:on



heroku maintenance:off
