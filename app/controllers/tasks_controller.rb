class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)
    if @task.save
      # do something
    else
      # do something
    end
  end

  def destroy
    @task = Task.find(task_params)
    # do something
    @task.destroy
  end

  private

  def task_params
    { id: 25 }
  end
end
