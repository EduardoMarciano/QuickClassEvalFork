require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe ManagerHelper, type: :helper do
  let(:admin) { User.create(email: 'admin@example.com', password: 'password', salt: 'salt', is_admin: true) }
  let(:user) { User.create(email: 'test@example.com', password: 'password', salt: 'salt') }
  let(:semester) { Semester.create(half: true, year: 2024) }

  describe '#admin_user?' do
    let(:timestamp) { 59.minutes.ago.to_i }

    context 'if the user is an admin' do
      before do
        cookies.signed[:user_info] = "T_#{timestamp}_#{admin.email}"
      end

      it 'returns true' do
        expect(helper.admin_user?).to be true
      end
    end

    context 'if the user is not an admin' do
      before do
        cookies.signed[:user_info] = "T_#{timestamp}_#{user.email}"
      end

      it 'returns false' do
        expect(helper.admin_user?).to be false
      end
    end
  end

  describe '#current_semester?' do
    it 'returns the current semester' do
      allow(Semester).to receive(:current_semester).and_return(semester)

      expect(helper.current_semester?).to eq(semester)
    end
  end
end
