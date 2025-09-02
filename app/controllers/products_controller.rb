class ProductsController < ApplicationController
  before_action :find_product, only: %i[show edit update destroy]

  def index
    @products = Product.all.with_attached_photo
  end

  def show
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found"
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted successfully."
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :photo)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end