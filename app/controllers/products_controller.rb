class ProductsController < ApplicationController
	before_action :authenticate_request

  def index
    @products = Product.all
    render json: @products
  end

 
  def show
    render json: @product
  end
  
  def create
    Rails.logger.debug("Incoming request parameters: #{params.inspect}")

    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    render json: { error: "Bad Request: Missing required parameters. Please provide the necessary parameters: #{e.param}" }, status: :bad_request
  rescue StandardError => e
    Rails.logger.error("Unexpected error in ProductsController#create: #{e.message}")
    render json: { error: " Something went wrong" }, status: :internal_server_error
  end
  

  private
   def product_params
      params.require(:product).permit(:name,:price,:user_id)
    end


end
