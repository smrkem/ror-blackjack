require "test_helper"

describe User do
  describe "validity" do
    let(:user) { User.new }

    before do
      user.valid?
    end

    it "requires an email" do
      user.errors[:email].must_include "can't be blank"
    end

    it "requires a password" do
      user.errors[:password].must_include "can't be blank"
    end

    it "starts with initial account" do
      user.email = 'test@test.ca'
      user.password = 'pass'
      user.save

      user.account.must_be_instance_of Account
      user.account.balance.must_equal 500
    end
  end
end
