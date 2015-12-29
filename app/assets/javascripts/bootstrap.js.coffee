console.log "bootstrapping.."
# localStorage.setItem "dummy", "toInitSqliteInNative"
# console.log "localStorage initialized"
#
# db = openDatabase('nativeBridgeDB', '1.0', 'NativeBridge DB', 5 * 1024 * 1024)
#
# db.transaction (tx) ->
#   tx.executeSql 'CREATE TABLE IF NOT EXISTS nativeBridge (id INTEGER PRIMARY KEY, message TEXT)'
#   console.log "table nativeBridge created or exists"

if navigator.userAgent.match(/(iPad|iPhone|iPod)/g)
  console.log "signaling native"
  window.location="#nativebridgebootstrapcomplete"
else
  console.log "not signaling native (we're not in iOS)"
