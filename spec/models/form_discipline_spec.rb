require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe FormDiscipline, type: :model do
  describe 'associations' do
    it 'should belong to a form' do
      association = FormDiscipline.reflect_on_association(:form)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'should belong to a discipline' do
      association = FormDiscipline.reflect_on_association(:discipline)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
