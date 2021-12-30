class BackgroundTasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def action
    ret = "BackgroundTasks::#{params[:name].camelize}".constantize.run(params.except(:name, :controller, :action))

    render json: ret || {}
  end
end
