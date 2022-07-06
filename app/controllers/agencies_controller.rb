class AgenciesController < ApplicationController
  
  def index
    agencies = Agency.all
    render json: agencies, status: :ok
  end

  def create
    agency = Agency.create(name: create_agency_params[:name])
    agency_cost = Cost.create(agency_id: agency.id, amount: create_agency_params[:cost])
    render json: agency, status: :ok
  end

  def sold
    render json: { agency: agency, sold: agency.sold, fees: agency.fees }
  end

  def transactions
    render json: { agency: agency, transactions: agency.transactions }
  end

  def transfer
    agency = Agency.find(transfer_params[:agency_id])
    sender, receiver, amount = transfer_params[:sender], transfer_params[:receiver], transfer_params[:amount]
    agency.transfer(agency.id, sender, receiver, amount)
    render json: { agency: agency, transactions: agency.transactions }
  end

  def withdraw
  end

  private
  def agency
    Agency.find(agency_params[:id])
  end

  def create_agency_params
    params.require(:agency).permit(:name, :cost)
  end

  def agency_params
    params.require(:agency).permit(:id)
  end

  def transfer_params
    params.require(:transfer).permit(:agency_id, :sender, :receiver, :amount)
  end

  def withdraw_params
  end
end