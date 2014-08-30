require 'rails_helper'

RSpec.describe Service, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    let!(:service_one) = { Service.create({ name: 'service_name',
                                slot_window: 15 }) }
    let!(:service_two) { Book.create(name: "Animal Farm") }

  end

  context 'validates services' do
    context 'check presence of service attributes' do
      it "name should not be empty " do
        service.name = nil
        service.should_not be_valid
      end
    end
  end

  context 'default scope' do

    it 'active records are fetched' do
      pending
    end
  end

end
