require 'rails_helper'

RSpec.describe Staff, :type => :model do

    let!(:staff_one) { Staff.create({ name: 'A_service_name',
                                phone_number: 6235463457,
                                email: 'a@a.com' }) }
    let!(:staff_two) { Staff.create({ name: 'B_service_name',
                                phone_number: 623578465,
                                email: 'b@b.com' }) }

  context 'default scope' do

    it 'shows ordered records' do
      Staff.all.should eq [staff_one, staff_two]
    end
  end

  context 'checks association' do
    it 'for having many staffs' do
      should have_and_belong_to_many(:services)
    end

    it 'for having many availabilities' do
      should have_many(:availabilities)
    end

    it { should accept_nested_attributes_for(:services) }
  end

  context 'callbacks' do
    it do
      staff_one.update_attribute('active', false)
      staff_one.availabilities.should be_empty
    end
  end
end
