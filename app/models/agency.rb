class Agency < ApplicationRecord
  has_one :cost
  has_many :agency_transactions, dependent: :destroy

  def sold
    agency_transactions.pluck(:amount).sum
  end

  def transactions
    agency_transactions
  end

  def fees
    agency_transactions.pluck(:fee).sum
  end

  def transfer(agency_id, sender_number, receiver_number, amount)
    agency = Agency.find(agency_id)
    sender = User.find_by(number: sender_number)
    receiver = User.find_by(number: receiver_number)
    code = generate_code
    # raise code.inspect
    ActiveRecord::Base.transaction do
      # Create a transaction (-) for sender 
      sender.user_transactions.create!(
        type_of: "transfer",
        user_id: sender.id,
        receiver_id: receiver.id,
        amount: -amount,
        code: code
      )
      # Create a transaction (+) for agency 
      agency_transactions.create!(
        agency_id: agency_id,
        type_of: "transfer",
        sender: sender,
        receiver: receiver,
        amount: amount_after_agency_cost(amount, agency_id),
        fee: agency_cost(agency_id),
        code: code
      )
      agency_transactions
    end
  end

  def withdraw
  end

  def tarif
    cost.amount
  end

  private
  def generate_code
    4.times.map{rand(10)}.join.to_i
  end

  def amount_after_agency_cost(amount, agency_id)
    amount - agency_cost(agency_id)
  end

  def agency_cost(agency_id)
    agency = Agency.find(agency_id)
    agency.tarif
  end
end
