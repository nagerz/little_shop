class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :orders, through: :order_items#, dependent: :delete_all

  validates :title, uniqueness: true, presence: true
  validates :description, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  def subtotal
    price * quantity
  end

  def fulfillment_time
    time = Item.joins(:orders)
      .where(id: self, orders: {status: 1})
      .group(:id)
      .select("avg(order_items.updated_at - order_items.created_at) as avg_time").first

    if !time.nil?
      time = time.avg_time
      time.split("days").first + "days, " + time.split("days").last.split(":").first.strip.to_i.round(0).to_s +  " hours"
    else
      nil
    end
  end

  def self.most_popular
    Item.joins(:orders)
    .select("items.*, sum(order_items.quantity) as total_quantity")
    .where(orders: {status: 1})
    .group(:id)
    .order("total_quantity desc")
  end

  def self.least_popular
    Item.joins(:orders)
    .select("items.*, sum(order_items.quantity) as total_quantity")
    .where(orders: {status: 1})
    .group(:id)
    .order("total_quantity asc")
  end
end
