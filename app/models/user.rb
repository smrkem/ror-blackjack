class User < ApplicationRecord
  include Clearance::User
  has_one :account
  before_create :build_account
end
