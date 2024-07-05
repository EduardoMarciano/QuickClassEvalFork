require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe SemestersController, type: :controller do
  let(:semester) { Semester.create(year: 2024, half: true) }

  describe 'GET #index' do
    context 'when there is a current semester' do
      before do
        allow(Semester).to receive(:current_semester_id).and_return(semester.id)
        allow(Semester).to receive(:to_csv).and_return('csv_data')
      end

      it 'redirects to manager path for HTML format' do
        get :index, format: :html

        expect(response).to redirect_to(manager_path)
      end

      it 'sends CSV data for CSV format' do
        get :index, format: :csv

        expect(response.header['Content-Disposition']).to include('filename="resultados_semestres.csv"')
        expect(response.body).to eq('csv_data')
      end
    end

    context 'when there is no current semester' do
      before do
        allow(Semester).to receive(:current_semester_id).and_return(nil)
      end

      it 'redirects to manager path with error message' do
        get :index

        expect(response).to redirect_to(manager_path)
        expect(flash[:error]).to eq('Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema.')
      end
    end
  end

  describe 'GET #show' do
    context 'when there is a current semester' do
      before do
        allow(Semester).to receive(:current_semester_id).and_return(semester.id)
        allow(Semester).to receive(:find).and_return(semester)
        allow(semester).to receive(:to_csv_single).and_return('csv_data')
      end

      it 'redirects to manager path for HTML format' do
        get :show, format: :html

        expect(response).to redirect_to(manager_path)
      end

      it 'sends CSV data for CSV format' do
        get :show, format: :csv

        expect(response.header['Content-Disposition']).to include("filename=\"resultados_#{semester}.csv\"")
        expect(response.body).to eq('csv_data')
      end
    end

    context 'when there is no current semester' do
      before do
        allow(Semester).to receive(:current_semester_id).and_return(nil)
      end

      it 'redirects to manager path with error message' do
        get :show

        expect(response).to redirect_to(manager_path)
        expect(flash[:error]).to eq('Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema.')
      end
    end
  end
end
