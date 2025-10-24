class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :order_number, type: String
  field :client_id,    type: String
  field :patient_id,   type: String
  field :diagnosis,    type: String
  field :treatment,    type: String
  field :date,         type: Date
  field :notes,        type: String

  validates :order_number, :client_id, :patient_id, :diagnosis, :date, presence: true
end
