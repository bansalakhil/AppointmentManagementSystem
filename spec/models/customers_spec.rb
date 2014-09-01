require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Customer, :type => :model do

    let!(:customer_one) { Customer.create({ name: 'A_service_name',
                                phone_number: 6235463457,
                                email: 'a@a.com' }) }
    let!(:customer_two) { Customer.create({ name: 'B_service_name',
                                phone_number: 623578465,
                                email: 'b@b.com' }) }

  context 'default scope' do

    it 'shows ordered records' do
      Customer.all.should eq [customer_one, customer_two]
    end
  end

end
