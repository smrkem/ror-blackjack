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

    it "requires a balance" do
      account.errors[:balance].must_include "can't be blank"
    end
  end
end
