require 'rails_helper'

RSpec.describe Availability, :type => :model do

  let!(:availability_one) { Availability.create({ start_time: '00:21:00',
                                             end_time: '00:12:00',
                                             start_date: '2014-12-12',
                                             end_date: '0012-12-12' }) }

  let!(:availability_two) { Availability.create({ start_time: '00:23:00',
                                             end_time: '00:12:00',
                                             start_date: '2014-12-12',
                                             end_date: '0012-12-12' }) }

  let!(:availability_three) { Availability.create({ start_time: '',
                                             end_time: '',
                                             start_date: '',
                                             end_date: '' }) }

  context 'validates presence of availability attributes' do
    it 'start_time' do
      availability_two.should be_valid
      availability_three.should_not be_valid
    end

    it 'end_time' do
      availability_two.should be_valid
      availability_three.should_not be_valid
    end

    it 'start_date' do
      availability_two.should be_valid
      availability_three.should_not be_valid
    end

    it 'end_date' do
      availability_two.should be_valid
      availability_three.should_not be_valid
    end
  end

  context 'checks default scope' do
    it 'order by start_date' do
      Availability.all.should eq [availability_one, availability_two]
    end
  end

  context 'checks association' do
    it { should belong_to(:service) }
    it { should belong_to(:staff) }
  end
end
