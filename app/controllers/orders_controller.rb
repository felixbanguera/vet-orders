class OrdersController < ApplicationController
  before_action :verify_api_key
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all
    render json: @orders
  end

  # GET /orders/:id
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    if @order.save
      render json: @order, status: :created
    else
      render json: { error: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /orders/:id
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: { error: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /orders/:id
  def destroy
    @order.destroy
    head :no_content
  end

  private

  def verify_api_key
    api_key = request.headers["x-api-key"]
    if api_key != ENV["API_KEY"]
      render json: { error: "Acceso denegado: API Key inválida o ausente" }, status: :forbidden
    end
  end

  def set_order
    @order = Order.find(params[:id])
  rescue Mongoid::Errors::DocumentNotFound
    render json: { error: "Orden no encontrada" }, status: :not_found
  end

  def order_params
    params.permit(:order_number, :client_id, :patient_id, :diagnosis, :treatment, :date, :notes)
  end
end
