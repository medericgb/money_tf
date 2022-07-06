module Errors
  class NegativeAmountError < StandardError; end

  class DepositError < StandardError; end

  class WithdrawError < StandardError; end

  class UnsufficentBalanceError < StandardError; end

  class UnexistingAgency < StandardError; end

  class OperationError < StandardError; end
end