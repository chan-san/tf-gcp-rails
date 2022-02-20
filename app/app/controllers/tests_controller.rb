class TestsController < ApplicationController
  before_action :set_test, only: :show

  def show
  end

  def index
    @tests = Test.all
  end

  private

  def set_test
    @test = Test.find(params[:id])
  end
end
