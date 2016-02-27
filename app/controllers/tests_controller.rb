class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy, :perform]

  def export
    export_name = params[:name]

    if export_name
      system("rm tmp/export.zip")
      system("rm tmp/*.csv") # dyno might stay the same
      system("rm tmp/*.txt")

      system("ruby export.rb #{params[:name]}")
      system("zip -pr tmp/export.zip tmp/*.{csv,txt}")
      send_file("tmp/export.zip", :type => "application/zip")
    else
      render :text => "name param missing"
    end
  end

  def reset
    system("rake db:migrate VERSION=0")
    system("rake db:migrate")
    #system("rake db:setup")
  end


  # GET /tests
  # GET /tests.json
  def index
    @tests = Test.all
  end

  def perform
    unless @test
      render "all_done"
    else

    method, amount, interval, payload, direction = @test.name.split('-')

    redirect_to test_results_path(@test, {
      direction: direction,
      method: method,
      amount: amount,
      interval: interval,
      payload: payload,
      next_test_id: (@test.id + 1)
      })
    end

  end

  # GET /tests/1
  # GET /tests/1.json
  def show
  end

  # GET /tests/new
  def new
    @test = Test.new
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)

    respond_to do |format|
      if @test.save
        format.html { redirect_to @test, notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: @test }
      else
        format.html { render :new }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to tests_url, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(:name)
    end
end
