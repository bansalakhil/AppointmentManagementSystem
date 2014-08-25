require 'rails_helper'

RSpec.describe Service, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before do
    @service = Service.create({:name => 'service_name',
                               :slot_window => 15 })
  end

  context 'check presence of service attributes' do
    it "name should not be empty " do
      @service.name = nil
      @service.should_not be_valid
    end
  end
end
