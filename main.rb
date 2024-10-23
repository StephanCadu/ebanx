require 'bundler/setup'
require 'sinatra'
require 'json'
require_relative 'app/controllers/events_controller'

before do
  content_type :json
end

# Rota de reset
post '/reset' do
  AccountService.reset
  status 200
  body 'OK'
end

# Rota para pegar o saldo
get '/balance' do
  account_id = params['account_id']
  balance = AccountService.get_balance(account_id)
  
  if balance.nil?
    status 404
    body '0'
  else
    status 200
    body balance.to_s
  end
end

# Rota para eventos
post '/event' do
  request_body = JSON.parse(request.body.read)
  event_type = request_body['type']

  case event_type
  when 'deposit'
    result = EventsController.deposit(request_body)
  when 'withdraw'
    result = EventsController.withdraw(request_body)
  when 'transfer'
    result = EventsController.transfer(request_body)
  else
    status 400
    body 'Invalid event type'
    return
  end

  # Define o status HTTP e a resposta com base no resultado do controlador
  status result[:status]
  result[:response].to_json
end
