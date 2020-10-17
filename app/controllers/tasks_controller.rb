class TasksController < ApplicationController

  def new # не появляется в routes
    @category = Category.find(params[:category_id])
  end

  def create
    @category = Category.find(params[:category_id])

    # connection 'one to one'. I catch an error when i do build_task because @task.id is exist
    return render('wrong') if @category.task

    @task = @category.build_task({ skip_products: false, recursive: false, state: 'pending', url_type: 'category' })
    @task.save ? redirect_to(categories_path) : render('wrong')
  end

  def destroy
    if params[:category_id] == '0'
      Task.delete_all
    else
      @category = Category.find(params[:category_id])
      @task.destroy
    end
    redirect_to(categories_path)
  end

  private

  def task_params
    # params.require(:task).permit(:title, :text)
  end
end
