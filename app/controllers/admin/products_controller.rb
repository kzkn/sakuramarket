class Admin::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :up, :down, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        path = admin_product_path(@product)
        format.html { redirect_to path, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: path }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        path = admin_product_path(@product)
        format.html { redirect_to path, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def up
    @product.move_higher
    redirect_to admin_products_path
  end

  def down
    @product.move_lower
    redirect_to admin_products_path
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to admin_products_path, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :image_file, :price, :description, :hidden)
    end
end
