class ResultsController < ApplicationController
  before_action :set_test_and_result, only: [:edit, :update, :destroy]
  before_action :set_test, only: [:index, :create, :destroy_all, :show]

  def index
    @results = @test.results
  end

  def create
    @result = @test.results.build result_params

    respond_to do |format|
      if @result.save
        format.html { render text: 'k.' }
        format.json { render json: {}, status: :created }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
  end

  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to edit_test_result_path(@test, @result), notice: 'Result was successfully updated.' }
        format.json { render json: {}, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_all
    @test.results.destroy_all
    respond_to do |format|
      format.html { redirect_to test_results_url(@test), notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_and_result
      @test = set_test
      @result = @test.results.find(params[:id])
    end

    def set_test
      @test = Test.find(params[:test_id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(
        :webview_started_at, :native_received_at, :native_started_at, :webview_received_at,
        :webview_payload_length, :native_payload_length,
        :from,
        :fps,
        :method_name,
        :cpu, :mem,
        :render_paused)
    end
end
