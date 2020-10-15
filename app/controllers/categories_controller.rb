class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    # @default = ActionController::Base.helpers.asset_path('../assets/images/default_auto.jpeg')
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category
    else
      render 'new'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :url)
  end

end

# По нажатию кнопки update_category сделать задание в таблице Tasks