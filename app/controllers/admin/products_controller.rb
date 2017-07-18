class Admin::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update]

  def index
    @products = Product.all.ordered
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
        format.html { redirect_to admin_product_path(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: admin_product_path(@product) }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to admin_product_path(@product), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_product_path(@product) }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
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
