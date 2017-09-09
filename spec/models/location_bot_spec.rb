require 'spec_helper'

describe LocationBot, type: :model do
  it { is_expected.to validate_uniqueness_of(:location_id).scoped_to(:bot_id) }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to belong_to(:bot) }
end
