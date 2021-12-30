class BackgroundTasksController < ApplicationController
  def action
    ret = "BackgroundTasks::#{params[:name].camelize}".constantize.run(params.except(:name, :controller, :action))

    render json: ret || {}
  end
end
