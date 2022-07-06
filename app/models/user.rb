class User < ApplicationRecord
  has_many :user_transactions, dependent: :destroy

  def sold
    cumul_sold = user_transactions.pluck(:amount).sum
  end

  def transactions
    user_transactions
  end
  
  def deposit(amount)
    # raise amount.inspect
    user_transactions.create!(type_of: "deposit", amount: amount.to_i, user_id: self.id)
  end

  def transfer(agency_id, receiver_number, amount)
    agency = Agency.find(agency_id)
    # receiver = User.find_by(number: receiver)
    code = generate_code

    ActiveRecord::Base.transaction do
      user_transactions.create!(
        type_of: "transfer",
        user_id: self.id,
        receiver: receiver_number,
        amount: -amount,
        code: code
      )
      #raise self.inspect
      agency.agency_transactions.create!(
        agency_id: agency_id,
        type_of: "transfer",
        sender: self.number,
        receiver: receiver_number,
        amount: amount_after_agency_cost(amount, agency_id),
        fee: agency_cost(agency_id),
        code: code
      )
    end
  end

  def withdraw(agency_id, code)
    agency = Agency.find(agency_id)
    agency_trs = AgencyTransaction.find_by(agency_id: agency_id, code: code)
    ActiveRecord::Base.transaction do
      user_transactions.create!(
        type_of: "withdraw",
        user_id: self.id,
        amount: agency_trs.amount,
        code: code
      )
      #raise self.inspect
      agency.agency_transactions.create!(
        agency_id: agency_id,
        type_of: "withdraw",
        receiver: self.number,
        amount: -agency_trs.amount,
      )
    end
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
