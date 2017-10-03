require 'rails_helper'

RSpec.describe Exercise, type: :model do
  it { should validate_presence_of(:performed_at) }
  it { should validate_presence_of(:duration_minutes) }
  it { should validate_presence_of(:avg_heart_rate) }
  it { should validate_presence_of(:created_by) }
end
