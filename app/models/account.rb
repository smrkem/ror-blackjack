class Account < ApplicationRecord
  belongs_to :user
  before_validation :init_balance

  validates :user, presence: true
  validates :balance, presence: true

  private
  def init_balance
    self.balance ||= 500
  end
end
