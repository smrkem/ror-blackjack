require "test_helper"

describe Account do
  describe "validity" do
    let(:account) { Account.new }

    before do
      account.valid?
    end

    it "requires a user" do
      account.errors[:user].must_include "can't be blank"
    end

    it "initializes a default balance" do
      account.user = create(:user)
      account.save

      assert_equal 500, account.balance
    end
  end
end
