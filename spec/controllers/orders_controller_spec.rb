# spec/requests/orders_request_spec.rb
require 'rails_helper'
require 'bson'

RSpec.describe "Orders API", type: :request do
  let(:api_key) { "test-api-key" }
  let(:headers) { { "Content-Type" => "application/json", "x-api-key" => api_key } }

  let(:valid_attributes) do
    {
      order_number: "ORD-1001",
      client_id: "client_abc_1",
      patient_id: "patient_xyz_10",
      diagnosis: "Otitis",
      treatment: "Antibiótico tópico",
      date: Date.today,
      notes: "Revisión en 10 días"
    }
  end

  let(:invalid_attributes) do
    {
      order_number: nil,
      client_id: nil,
      patient_id: nil,
      diagnosis: nil,
      date: nil
    }
  end

  before do
    # Mockear la API_KEY en ENV para las pruebas
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("API_KEY").and_return(api_key)
  end

  describe "GET /orders" do
    it "retorna la lista de órdenes" do
      Order.create!(valid_attributes)
      get "/orders", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_an(Array)
      expect(body.first["order_number"]).to eq("ORD-1001")
    end
  end

  describe "GET /orders/:id" do
    it "retorna una orden específica" do
      order = Order.create!(valid_attributes)
      get "/orders/#{order.id}", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["order_number"]).to eq("ORD-1001")
      expect(json["client_id"]).to eq("client_abc_1")
      expect(json["patient_id"]).to eq("patient_xyz_10")
    end

    it "retorna 404 si no existe" do
      non_existent_id = BSON::ObjectId.new.to_s
      get "/orders/#{non_existent_id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /orders" do
    it "crea una orden válida" do
      expect {
        post "/orders", params: valid_attributes.to_json, headers: headers
      }.to change(Order, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["order_number"]).to eq("ORD-1001")
      expect(json["diagnosis"]).to eq("Otitis")
    end

    it "retorna error si faltan campos requeridos" do
      post "/orders", params: invalid_attributes.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to be_present
    end
  end

  describe "PUT /orders/:id" do
    it "actualiza una orden existente" do
      order = Order.create!(valid_attributes)
      updated_attributes = { treatment: "Nuevo tratamiento oral", notes: "Cambio de pauta" }

      put "/orders/#{order.id}", params: updated_attributes.to_json, headers: headers
      expect(response).to have_http_status(:ok)

      order.reload
      expect(order.treatment).to eq("Nuevo tratamiento oral")
      expect(order.notes).to eq("Cambio de pauta")
    end

    it "retorna 404 al actualizar una orden inexistente" do
      non_existent_id = BSON::ObjectId.new.to_s
      put "/orders/#{non_existent_id}", params: { treatment: "x" }.to_json, headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /orders/:id" do
    it "elimina una orden" do
      order = Order.create!(valid_attributes)

      expect {
        delete "/orders/#{order.id}", headers: headers
      }.to change(Order, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "retorna 404 al eliminar una orden inexistente" do
      non_existent_id = BSON::ObjectId.new.to_s
      delete "/orders/#{non_existent_id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
