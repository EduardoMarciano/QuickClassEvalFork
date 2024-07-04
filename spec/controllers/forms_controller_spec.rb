# Teste unitario para controller FormsController
require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe FormsController, type: :controller do
  let(:user) { User.create(email: 'test@example.com', password: 'password', salt: 'salt') }
  let(:admin) { User.create(email: 'admin@example.com', password: 'password', salt: 'salt', is_admin: true) }
  let(:semester) { Semester.create(half: true, year: 2024) }
  let(:discipline) do
    Discipline.create(name: 'Sample Discipline', code: 'DISC1234', professor_registration: 'PROF1234')
  end
  let(:form) { Form.create(discipline:) }
  let(:question) do
    Question.create(label: 'Sample Question', description: 'Sample Description', format: 'text', formlike: form)
  end
  let(:answer) { Answer.create(answer: 'Sample Answer', user:, question:) }

  before do
    allow(controller).to receive(:logged_user).and_return(user)
  end

  describe 'GET #index' do
    context 'when user is not authenticated' do
      before { allow(controller).to receive(:user_authenticated).and_return(false) }

      it 'redirects to root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is authenticated but not admin' do
      before { allow(controller).to receive(:user_authenticated).and_return(true) }
      before { allow(controller).to receive(:admin_user?).and_return(false) }

      it 'redirects to root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is authenticated and admin' do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:admin_user?).and_return(true)
      end

      it 'assigns all forms to @forms' do
        form
        get :index
        expect(assigns(:forms)).to eq([form])
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not authenticated' do
      before { allow(controller).to receive(:user_authenticated).and_return(false) }

      it 'redirects to root path' do
        get :show, params: { id: form.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is authenticated but does not belong to the discipline' do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:user_belongs_to?).and_return(false)
      end

      it 'redirects to root path' do
        get :show, params: { id: form.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is authenticated and belongs to the discipline' do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:user_belongs_to?).and_return(true)
      end

      it 'assigns the requested form to @form' do
        get :show, params: { id: form.id }
        expect(assigns(:form)).to eq(form)
      end

      it 'assigns answers to @answers' do
        answer
        get :show, params: { id: form.id }
        expect(assigns(:answers)[question.id]).to eq(answer)
      end
    end
  end

  describe 'POST #create' do
    it 'logs the received parameters' do
      params = ActionController::Parameters.new(questions: { '1' => 'Answer' })
      expect(Rails.logger).to receive(:debug).with("Received: #{params[:questions].inspect}")
      post :create, params: { questions: { '1' => 'Answer' } }
    end
  end

  describe 'PATCH #update' do
    before do
      allow(controller).to receive(:user_authenticated).and_return(true)
      allow(controller).to receive(:user_belongs_to?).and_return(true)
    end

    context 'when user is not authenticated' do
      before do
        allow(controller).to receive(:user_belongs_to?).and_return(false)
      end

      it 'redirects to root path' do
        patch :update, params: { id: form.id, questions: { question.id.to_s => 'Answer' } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user does not belong to the discipline' do
      before { allow(controller).to receive(:user_belongs_to?).and_return(false) }

      it 'redirects to root path' do
        patch :update, params: { id: form.id, questions: { question.id.to_s => 'Answer' } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is authenticated and belongs to the discipline' do
      before { allow(controller).to receive(:user_belongs_to?).and_return(true) }

      it 'creates answers for valid questions' do
        patch :update, params: { id: form.id, questions: { question.id.to_s => 'Answer' } }
        expect(Answer.where(user:, question:).first.answer).to eq('Answer')
      end

      it 'redirects to evaluations path with a success flash message' do
        patch :update, params: { id: form.id, questions: { question.id.to_s => 'Answer' } }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:success]).to eq('Formulário respondido com sucesso')
      end
    end
  end
end
