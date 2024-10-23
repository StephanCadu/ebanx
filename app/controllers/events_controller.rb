require_relative '../services/account_service'
require 'sinatra'

class EventsController < Sinatra::Base
  def self.deposit(request_body)
    destination_id = request_body['destination']
    amount = request_body['amount']
    account = AccountService.deposit(destination_id, amount)

    { status: 201, response: { destination: { id: account.id, balance: account.balance } } }
  end

  def self.withdraw(request_body)
    origin_id = request_body['origin']
    amount = request_body['amount']
    account = AccountService.withdraw(origin_id, amount)

    if account.nil?
      { status: 404, response: 0 }
    else
      { status: 201, response: { origin: { id: account.id, balance: account.balance } } }
    end
  end

  def self.transfer(request_body)
    origin_id = request_body['origin']
    destination_id = request_body['destination']
    amount = request_body['amount']

    result = AccountService.transfer(origin_id, destination_id, amount)

    if result[:status] == :not_found
      { status: 404, response: 0 }
    else
      { status: 201, response: result[:response] }
    end
  end
end
