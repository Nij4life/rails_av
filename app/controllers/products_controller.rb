class ProductsController < ApplicationController
  def index; end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
