require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe TemplatesController, type: :controller do
  let(:admin_user) { User.create(email: 'admin@example.com', password: 'password', salt: 'salt', is_admin: true) }
  let(:template) { Template.create }

  context 'when user is authenticated and an admin' do
    before do
      allow(controller).to receive(:user_authenticated).and_return true
      allow(controller).to receive(:admin_user?).and_return true
    end

    describe 'GET #index' do
      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #new' do
      it 'renders the new templates page' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #show' do
      it 'renders the show templates page' do
        get :show, params: { id: template.id }
        expect(response).to render_template :show
      end
    end

    describe 'POST #create' do
      let(:question1) do
        TextInputQuestion.create label: 'foo', description: 'bar'
      end
      let(:question2) do
        MultipleChoiceQuestion.create label: 'foo', description: 'bar', format: 'foo|bar|baz'
      end

      it 'creates a new template' do
        question1_params = {
          label: question1.label,
          description: question1.description,
          type: question1.type,
          format: question1.format
        }
        question2_params = {
          label: question2.label,
          description: question2.description,
          type: question2.type,
          format: question2.format
        }

        expect do
          post :create, params: { questions: [question1_params, question2_params] }
        end.to change(Template, :count).by(1)
        expect(Template.last.questions.first).to have_attributes(question1_params)
        expect(Template.last.questions.last).to have_attributes(question2_params)
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the template' do
        expect do
          delete :destroy, params: {
            id: template.id,
            _method: :delete,
            _action: :destroy,
            controller: :templates
          }
        end.to change(Template, :count).by(0)
      end
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
        post :send_out_forms, params: { template_id: template.id, discipline_ids: [discipline1.id, discipline2.id] }
        expect(Form.where(template_id: template.id, discipline_id: discipline1.id)).to exist
        expect(Form.where(template_id: template.id, discipline_id: discipline2.id)).to exist
      end

      it 'redirects to manager path after sending forms' do
        post :send_out_forms, params: { template_id: template.id, discipline_ids: [discipline1.id, discipline2.id] }
        expect(response).to redirect_to(manager_path)
      end

      it 'sets error flash message if no disciplines are selected' do
        post :send_out_forms, params: { template_id: template.id, discipline_ids: [] }
        expect(flash[:error]).to eq('Nenhuma disciplina foi selecionada para envio')
        expect(response).to redirect_to(manager_path)
      end

      it 'redirects to root path if user is not admin' do
        allow(controller).to receive(:admin_user?).and_return(false)
        post :send_out_forms, params: { template_id: template.id, discipline_ids: [discipline1.id, discipline2.id] }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'when user is not authenticated' do
    before do
      allow(controller).to receive(:user_authenticated).and_return false
    end

    describe 'GET #index' do
      it 'redirects to root_path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
end
