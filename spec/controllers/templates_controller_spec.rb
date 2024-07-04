# Teste unitario para controller TemplatesController
require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe TemplatesController, type: :controller do
  let(:admin_user) { User.create(email: 'admin@example.com', password: 'password', salt: 'salt', is_admin: true) }
  let(:template) { Template.create }

  before do
    allow(controller).to receive(:user_authenticated).and_return(true)
    allow(controller).to receive(:admin_user?).and_return(true)
  end

  describe 'GET #edit_send' do
    it 'assigns all disciplines and templates to render the edit_send template' do
      get :edit_send
      expect(assigns(:disciplines)).to eq(Discipline.all)
      expect(assigns(:templates)).to eq(Template.all)
      expect(response).to render_template('templates/send/index')
    end

    it 'redirects to root path if user is not admin' do
      allow(controller).to receive(:admin_user?).and_return(false)
      get :edit_send
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST #send_out_forms' do
    let(:discipline1) { Discipline.create(name: 'Discipline 1', code: 'DISC1') }
    let(:discipline2) { Discipline.create(name: 'Discipline 2', code: 'DISC2') }

    it 'sends out forms to selected disciplines' do
      post :send_out_forms, params: { template_id: template.id, discipline_ids: ["", discipline1.id, discipline2.id] }
      expect(Form.where(template_id: template.id, discipline_id: discipline1.id)).to exist
      expect(Form.where(template_id: template.id, discipline_id: discipline2.id)).to exist
    end

    it 'redirects to manager path after sending forms' do
      post :send_out_forms, params: { template_id: template.id, discipline_ids: [discipline1.id, discipline2.id] }
      expect(response).to redirect_to(manager_path)
    end

    it 'sets error flash message if no disciplines are selected' do
      post :send_out_forms, params: { template_id: template.id, discipline_ids: [] }
      expect(flash[:error]).to eq('Nenhuma disciplina foi selecionada para envio.')
      expect(response).to redirect_to("/templates/send")
    end

    it 'redirects to root path if user is not admin' do
      allow(controller).to receive(:admin_user?).and_return(false)
      post :send_out_forms, params: { template_id: template.id, discipline_ids: [discipline1.id, discipline2.id] }
      expect(response).to redirect_to(root_path)
    end
  end
end
