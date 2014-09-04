require 'rails_helper'

describe Staff do

    let!(:staff_three) { Staff.create({ name: 'C_service_name',
                                phone_number: 623578465,
                                email: 'c@c.com',
                                active: true }) }
    let(:avail){ Availability.create() }
    let!(:staff_two) do
      s = Staff.create({ name: 'B_service_name',
                                phone_number: 623578465,
                                email: 'b@b.com',
                                active: true })
      s.availabilities = [avail]
      s.save!
      s
    end
    let!(:staff_one) { Staff.create({ name: 'A_service_name',
                                phone_number: 6235463457,
                                email: 'a@a.com',
                                active: false }) }
    let!(:all_staff) { Staff.all }

  describe 'default scope' do

    it { expect(all_staff.count).to eq 2 }
    it { expect(all_staff[0].name).to eq 'B_service_name' }
    it { expect(all_staff[1].name).to eq 'C_service_name' }
  end

  describe 'checks association' do

    it { should have_and_belong_to_many(:services) }
    it { should have_many(:availabilities) }
    it { should accept_nested_attributes_for(:services) }
  end

  describe 'callbacks' do
    it do
      staff_two.update_attribute('active', false)
      expect(staff_two.availabilities).to be_empty
    end
  end
end
