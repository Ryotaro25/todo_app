module Api
  class Api::TasksController < ApplicationController
    protect_from_forgery
    
    def index
      @tasks = Task.order('created_at DESC')
    end

    def create
      @task = Task.new(task_params)

      if @task.save
        render json: @task, status: :created
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def destroy
      Task.find(params[:id]).destroy!
    end

    def update
      Task.find(params[:id]).toggle!(:is_done)
    end

    private def task_params
      params.require(:task).permit(:name, :is_done)
    end
  end
end
