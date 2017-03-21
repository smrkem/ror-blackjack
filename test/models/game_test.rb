require "test_helper"

describe Game do
  describe "validity" do
    let(:game) { Game.new }

    before do
      game.valid?
    end

    it "requires a user" do
      game.errors[:user].must_include "can't be blank"
    end

  end
end
