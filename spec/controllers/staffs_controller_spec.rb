require 'rails_helper'

describe StaffsController do

  let(:service1) { Service.create({ name: 'service_one', slot_window: 15 })}
  let(:initial_staff) { Staff.create({ name: 'initial_name', email: 'initial@initia.com', phone_number: 635635635635, service_ids: [service1.id] }) }

  before do
    sign_in
  end

  describe 'constants' do
    it { StaffsController::PERMITTED_ATTRS.should eq [:name, :email, :phone_number, {service_ids: []}] }
  end

  describe 'blocks unauthenticated access' do
    it do
      sign_in nil
      get :index
      response.should redirect_to(root_path)
    end
  end

  describe 'GET #index' do
    before do
      get :index
    end

    # it 'assigns instance variable @staffs' do
    #   assigns()
    # end

    it { expect(response).to have_http_status(200) }
    it { should render_template('index') }
  end

  describe 'POST #create' do
    before do
      xhr :post, :create, params, format: :js
    end

    context 'sucessfull creation' do
      let(:params) { {staff: { name: 'staff_one', email: 'staff_one@staff_one.com', phone_number: 635635635635, service_ids: [service1.id] } } }

      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template('refresh') }
      it { expect(flash[:notice]).to eq('Staff sucessfully created') }
    end

    context 'unsuccessfull creation' do
      let(:params) { {staff: { name: '', email: '', phone_number: '', service_ids: [] } } }
      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template('edit') }
      it { expect(flash[:notice]).to eq('Staff could not be created') }
    end
  end

  describe 'PUT #update' do
    before do
      xhr :put, :update, {id: initial_staff.id}.merge(params)
    end

    context 'sucessfull updation' do
      let(:params) { {staff: { name: 'staff_one', email: 'staff_one@staff_one.com', phone_number: 635635635635, service_ids: [service1.id] } } }
      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template('refresh') }
      it { expect(flash[:notice]).to eq('Staff sucessfully updated') }
    end

    context 'unsuccessfull updation' do
      let(:params) { {staff: { name: '', email: 'staff_one@staff_one.com', phone_number: 635635635635, service_ids: [service1.id] } } }
      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template('edit') }
      it { expect(flash[:notice]).to eq('Staff could not be updated') }
    end
  end

  describe 'PUT #deactivate' do
    before do
      put :deactivate, {id: initial_staff.id}.merge(params)
      initial_staff.reload
    end

    context 'sucessfull deactivation' do
      let(:params) { {staff: { name: 'staff_one', email: 'staff_one@staff_one.com', phone_number: 635635635635, service_ids: [service1.id] } } }
      it { expect(response).to have_http_status(302) }
      it { expect(initial_staff[:active]).to eq (false) }
      it { expect(response).to redirect_to :action => :index }
      it { expect(flash[:notice]).to eq('Staff sucessfully deleted') }
    end
  end

end