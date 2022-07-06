class UsersController < ApplicationController
  before_action :set_user_by_number, only: [:transaction]

  def index
    users = User.all
    render json: users, status: :ok
  end

  def create
    user = User.new(create_user_params)
    if user.save
      render json: user, status: :ok
    end
  end
  
  def sold
    render json: { user: user, sold: user.sold }, status: :ok if user
  end

  def transactions
    render json: { user: user, transactions: user.transactions }, status: :ok if user
  end

  def deposit
    user = User.find_by(number: deposit_params[:number])
    user.deposit(deposit_params[:amount])
    render json: { user: user, sold: user.sold }, status: :ok
  end

  def transfer
    agency = Agency.find(transfer_params[:agency_id])
    sender = User.find_by(number: transfer_params[:sender])
    receiver, amount = transfer_params[:receiver], transfer_params[:amount]
    sender.transfer(agency.id, receiver, amount)
    render json: { user: sender, transactions: sender.transactions }
  end

  def withdraw
    agency_id = withdraw_params[:agency_id]
    code = withdraw_params[:code]
    agency_trs = AgencyTransaction.find_by(agency_id: agency_id, code: code)
    receiver_number = agency_trs.receiver
    receiver = User.find_by(number: receiver_number)
    receiver.withdraw(agency_id, code)
    render json: { user: receiver, transactions: receiver.transactions }
  end

  private
  def user
    user = User.find_by(number: user_number_params[:number])
  end

  def user_params
    params.require(:user).permit(:id)
  end

  def set_user_by_number
    User.find_by(number: params[:number])
  end

  def user_number_params
    params.require(:user).permit(:number)
  end

  def create_user_params
    params.require(:user).permit(:name, :number)
  end

  def deposit_params
    params.require(:deposit).permit(:number, :amount)
  end

  def transfer_params 
    params.require(:transfer).permit(:agency_id, :sender, :receiver, :amount)
  end

  def withdraw_params
    params.require(:withdraw).permit(:agency_id, :code)
  end
end