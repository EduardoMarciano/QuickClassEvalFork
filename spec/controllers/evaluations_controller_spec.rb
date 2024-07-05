require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe EvaluationsController, type: :controller do
  let(:user) { User.create(email: 'test@example.com', salt: '$2a$12$9sauXRcV/alggmsRweudU.', password: 'password') }
  let(:discipline) do
    Discipline.create(name: 'Test Discipline', code: 'TD001', professor_registration: '123', semester_id: 1)
  end

  describe 'GET #index' do
    context 'when user is authenticated' do
      before do
        allow(controller).to receive(:logged_user).and_return(user)
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:admin_user?).and_return(false)
      end

      it 'assigns @disciplines_info and renders the index template' do
        disciplines_info = []
        allow(Discipline).to receive(:all_disciplines_with_eval_info).and_return(disciplines_info)

        get :index

        expect(assigns(:disciplines_info)).to eq(disciplines_info)
        expect(response).to render_template('index')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to root path with alert' do
        get :index

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso não autorizado')
      end
    end
  end

  describe 'GET #disciplines' do
    context 'when user is authenticated' do
      before do
        allow(controller).to receive(:logged_user).and_return(user)
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:admin_user?).and_return(false)
      end

      it 'assigns @disciplines_info and renders the disciplines template' do
        disciplines_info = []
        allow(Discipline).to receive(:all_disciplines_info).and_return(disciplines_info)

        get :disciplines

        expect(assigns(:disciplines_info)).to eq(disciplines_info)
        expect(response).to render_template('disciplines')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to root path with alert' do
        get :disciplines

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso não autorizado')
      end
    end
  end

  describe 'GET #show' do
    before do
      allow(Discipline).to receive(:find).with(discipline.id.to_s).and_return(discipline)
    end

    context 'when format is HTML' do
      it 'redirects to evaluations path' do
        get :show, params: { id: discipline.id }, format: :html

        expect(response).to redirect_to(evaluations_path)
      end
    end

    context 'when format is CSV' do
      before do
        allow(discipline).to receive(:to_csv_single).and_return('csv_data')
      end

      it 'sends the CSV data' do
        get :show, params: { id: discipline.id }, format: :csv

        expect(response.header['Content-Disposition']).to include("filename=\"#{discipline.name}.csv\"")
        expect(response.body).to eq('csv_data')
      end
    end
  end
end
