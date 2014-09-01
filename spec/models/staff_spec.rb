require 'rails_helper'

RSpec.describe Staff, :type => :model do

    let!(:staff_one) { Customer.create({ name: 'A_service_name',
                                phone_number: 6235463457,
                                email: 'a@a.com' }) }
    let!(:staff_two) { Customer.create({ name: 'B_service_name',
                                phone_number: 623578465,
                                email: 'b@b.com' }) }
  context 'validates services' do
    context 'check presence of service attributes' do
      it "name should not be empty " do
        staff_one.name = nil
        staff_one.should_not be_valid
        staff_two.should be_valid
        # staff_one.should validate_presence_of(:name)
      end
    end
  end

  context 'default scope' do

    it 'shows ordered records' do
      Customer.all.should eq [customer_one, customer_two]
    end
  end

  context 'checks association' do
    it 'for having many staffs' do
      should have_and_belong_to_many(:services)
        # join_table('ServicesAndStaffs')
    end

    it 'for having many availabilities' do
      should have_many(:availabilities)
    end
  end

  context 'callbacks' do
  end
end
