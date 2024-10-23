require_relative '../models/account'

class AccountService
    @accounts = {}
  
    def self.reset
      @accounts = {}
    end
  
    def self.get_balance(account_id)
      account = @accounts[account_id]
      account&.balance
    end
  
    def self.deposit(destination_id, amount)
      account = @accounts[destination_id] || ::Account.new(destination_id)
      account.balance += amount
      @accounts[destination_id] = account
      account
    end
  
    def self.withdraw(origin_id, amount)
      account = @accounts[origin_id]
      return nil unless account && account.balance >= amount
  
      account.balance -= amount
      account
    end
  
    def self.transfer(origin_id, destination_id, amount)
      origin_account = @accounts[origin_id]
      destination_account = @accounts[destination_id] || ::Account.new(destination_id)
  
      return { status: :not_found } unless origin_account && origin_account.balance >= amount
  
      origin_account.balance -= amount
      destination_account.balance += amount
  
      @accounts[destination_id] = destination_account
  
      { status: :success, response: { origin: { id: origin_account.id, balance: origin_account.balance }, destination: { id: destination_account.id, balance: destination_account.balance } } }
    end
  end
  