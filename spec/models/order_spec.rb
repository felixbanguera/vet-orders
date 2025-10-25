require 'rails_helper'

RSpec.describe Order, type: :model do
  context "validaciones" do
    it "es válido con todos los atributos requeridos" do
      order = Order.new(
        order_number: "ORD-2001",
        client_id: 5,
        patient_id: 15,
        diagnosis: "Dermatitis alérgica",
        treatment: "Antihistamínicos orales",
        date: Date.today,
        notes: "Revisión en una semana"
      )
      expect(order).to be_valid
    end

    it "no es válido sin order_number" do
      order = Order.new(
        client_id: 5,
        patient_id: 15,
        diagnosis: "Otitis externa",
        treatment: "Antibiótico tópico",
        date: Date.today
      )
      expect(order).not_to be_valid
      expect(order.errors[:order_number]).to include("can't be blank")
    end

    it "no es válido sin client_id" do
      order = Order.new(
        order_number: "ORD-2002",
        patient_id: 10,
        diagnosis: "Gastroenteritis",
        treatment: "Dieta blanda",
        date: Date.today
      )
      expect(order).not_to be_valid
      expect(order.errors[:client_id]).to include("can't be blank")
    end

    it "no es válido sin patient_id" do
      order = Order.new(
        order_number: "ORD-2003",
        client_id: 3,
        diagnosis: "Conjuntivitis",
        treatment: "Colirio antibiótico",
        date: Date.today
      )
      expect(order).not_to be_valid
      expect(order.errors[:patient_id]).to include("can't be blank")
    end

    it "no es válido sin diagnosis" do
      order = Order.new(
        order_number: "ORD-2004",
        client_id: 1,
        patient_id: 2,
        treatment: "Corticoides tópicos",
        date: Date.today
      )
      expect(order).not_to be_valid
      expect(order.errors[:diagnosis]).to include("can't be blank")
    end

    it "no es válido sin fecha" do
      order = Order.new(
        order_number: "ORD-2005",
        client_id: 1,
        patient_id: 2,
        diagnosis: "Anemia",
        treatment: "Suplemento de hierro"
      )
      expect(order).not_to be_valid
      expect(order.errors[:date]).to include("can't be blank")
    end
  end

  context "estructura del documento" do
    it "guarda correctamente en MongoDB" do
      order = Order.create!(
        order_number: "ORD-3001",
        client_id: 7,
        patient_id: 14,
        diagnosis: "Otitis media",
        treatment: "Antibiótico oral",
        date: Date.today,
        notes: "Revisión en 5 días"
      )

      found = Order.find(order.id)
      expect(found.order_number).to eq("ORD-3001")
      expect(found.diagnosis).to eq("Otitis media")
    end
  end
end