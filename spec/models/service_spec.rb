require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Service, :type => :model do

    let!(:service_one) { Service.create({ name: 'service_name1',
                                slot_window: 15, active: true}) }
    let!(:service_two) { Service.create({ name: 'service_name2',
                                slot_window: 30, active: false}) }

  context 'validates services' do
    context 'check presence of service attributes' do
      it "name should not be empty " do
        service_one.name = nil
        service_one.should_not be_valid
        service_two.should be_valid
        # service_one.should validate_presence_of(:name)
      end
    end
  end

  context 'default scope' do

    it 'fetches active records only' do
      Service.all.should eq [service_one]
      Service.unscoped.all.should eq [service_one, service_two]
    end
  end

  context 'checks association' do
    it 'for having many staffs' do
      should have_and_belong_to_many(:staffs)
        # join_table('ServicesAndStaffs')
    end
  end

end
