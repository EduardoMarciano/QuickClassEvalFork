require 'rails_helper'

require 'simplecov'
SimpleCov.start

class DummyController < ApplicationController
  include AuthenticationConcern
end

RSpec.describe DummyController, type: :controller do
  let!(:user) do
    User.create(email: 't@gmail.com', salt: '$2a$12$9sauXRcV/alggmsRweudU.',
                password: '$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu', session_key: 'T')
  end

  controller do
    def index
      if user_authenticated
        render plain: 'Authenticated'
      else
        render plain: 'Not Authenticated'
      end
    end

    def set_signed_cookies(key, value)
      cookies.signed[key] = value
    end
  end

  describe '#logged_user' do
    context 'when user is authenticated' do
      before do
        timestamp = 59.minutes.ago.to_i
        controller.set_signed_cookies(:user_info, "T_#{timestamp}_t@gmail.com")
        allow(controller).to receive(:user_authenticated).and_return(true)
      end

      it 'returns the logged user' do
        expect(controller.logged_user).to eq(user)
      end
    end

    context 'when user is not authenticated' do
      before do
        allow(controller).to receive(:user_authenticated).and_return(false)
      end

      it 'returns nil' do
        expect(controller.logged_user).to be_nil
      end
    end
  end

  describe 'user_authenticated' do
    context 'with valid session' do
      before do
        timestamp = 59.minutes.ago.to_i
        cookies.signed[:user_info] = "T_#{timestamp}_t@gmail.com"
      end

      it 'returns true and renders Authenticated' do
        get :index
        expect(response.body).to eq('Authenticated')
      end
    end

    context 'with expired session' do
      before do
        timestamp = 2.hours.ago.to_i
        cookies.signed[:user_info] = "T_#{timestamp}_t@gmail.com"
      end

      it 'returns false and renders Not Authenticated' do
        get :index
        expect(response.body).to eq('Not Authenticated')
        expect(cookies[:user_info]).to be_nil
      end
    end

    context 'with invalid session key' do
      before do
        timestamp = 10.minutes.ago.to_i
        cookies.signed[:user_info] = "INVALID_#{timestamp}_t@gmail.com"
      end

      it 'returns false and renders Not Authenticated' do
        get :index
        expect(response.body).to eq('Not Authenticated')
        expect(cookies[:user_info]).to be_nil
      end
    end

    context 'with missing user info' do
      before do
        cookies.signed[:user_info] = nil
      end

      it 'returns false and renders Not Authenticated' do
        get :index
        expect(response.body).to eq('Not Authenticated')
      end
    end
  end

  describe '#user_belongs_to?' do
    let!(:semester) { Semester.create!(half: false, year: 2024) }
    let!(:discipline) { Discipline.create!(name: 'foo', code: 'DISC456') }
    let!(:student_discipline) do
      StudentDiscipline.create!(student_email: user.email,
                                discipline_code: discipline.code,
                                semester_id: semester.id)
    end
    let!(:another_discipline) { Discipline.create!(name: 'foo', code: 'DISC457') }

    context 'when logged user belongs to the discipline' do
      before do
        allow(controller).to receive(:logged_user).and_return(user)
        allow(controller).to receive(:user_authenticated).and_return(true)
      end

      it 'returns true' do
        expect(controller.user_belongs_to?([discipline, another_discipline])).to be true
      end
    end

    context 'when logged user does not belong to the discipline' do
      before do
        allow(controller).to receive(:logged_user).and_return(user)
      end

      it 'returns false' do
        expect(controller.user_belongs_to?([another_discipline])).to be false
      end
    end
  end
end
