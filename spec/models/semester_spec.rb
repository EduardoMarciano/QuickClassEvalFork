require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Semester, type: :model do
  describe '.next_semester_id' do
    context 'when no semesters exist' do
      it 'creates a new semester starting from year 2020 and half 0' do
        expect {
          Semester.next_semester_id
        }.to change(Semester, :count).by(1)

        new_semester = Semester.last
        expect(new_semester.year).to eq(2020)
        expect(new_semester.half).to eq(false)
      end
    end

    context 'when latest semester is in half' do
      before do
        Semester.create(year: 2023, half: 1)
      end

      it 'creates a new semester in the next year' do
        expect {
          Semester.next_semester_id
        }.to change(Semester, :count).by(1)

        new_semester = Semester.last
        expect(new_semester.year).to eq(2024)
        expect(new_semester.half).to eq(false)
      end
    end

    context 'when latest semester is not half' do
      before do
        Semester.create(year: 2023, half: 0)
      end

      it 'creates a new semester in the same year that is half' do
        expect {
          Semester.next_semester_id
        }.to change(Semester, :count).by(1)

        new_semester = Semester.last
        expect(new_semester.year).to eq(2023)
        expect(new_semester.half).to eq(true)
      end
    end
  end

  describe '.current_semester' do
    context 'when there are semesters' do
      it 'returns the formatted current semester' do
        Semester.create(year: 2023, half: 1)

        expect(Semester.current_semester).to eq("2023.2.")
      end
    end

    context 'when there are no semesters' do
      it 'returns a message indicating no semester is registered' do
        expect(Semester.current_semester).to eq("Sem semestre cadastrado.")
      end
    end
  end

  describe '.current_semester_id' do
    context 'when there are semesters' do
      it 'returns the ID of the latest semester' do
        semester = Semester.create(year: 2023, half: 1)

        expect(Semester.current_semester_id).to eq(semester.id)
      end
    end

    context 'when there are no semesters' do
      it 'returns nil' do
        expect(Semester.current_semester_id).to be_nil
      end
    end
  end

  describe 'to_s' do
    context 'when semester is not half' do
      it 'returns 1 plus the year of the semester' do
        semester = Semester.create(year: 2023, half: false)

        expect(semester.to_s.split('-')[0]).to eq('1')
        expect(semester.to_s.split('-')[1]).to eq('2023')
      end
    end

    context 'when semester is half' do
      it 'returns 2 plus the year of the semester' do
        semester = Semester.create(year: 2023, half: true)

        expect(semester.to_s.split('-')[0]).to eq('2')
        expect(semester.to_s.split('-')[1]).to eq('2023')
      end
    end
  end

  describe '.to_csv' do
    it 'converts each semester to a CSV' do
      Semester.create(half: false, year: 2020)
      Semester.create(half: true, year: 2020)
        
      Semester.to_csv
    end
  end

  describe '.each_csv' do
    it 'iterates over each semester and call to_csv' do
      Semester.create(half: false, year: 2020)
      Semester.create(half: true, year: 2020)

      CSV.generate(headers: true, col_sep: ";") do |csv|
        Semester.each_csv(csv)
      end
    end
  end

  describe '#to_csv' do
    it 'converts the semester to a CSV' do
      semester = Semester.create(half: false, year: 2020)
      Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
      Template.create()
      Form.create(template_id: 1, discipline_id: 1)

      CSV.generate(headers: true, col_sep: ";") do |csv|
        semester.to_csv(csv)
      end

    end
  end

  describe '#to_csv_single', focus: true do
    it 'converts the semester to a CSV' do
      semester = Semester.create(half: false, year: 2020)
      Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
      Template.create()
      Form.create(template_id: 1, discipline_id: 1)
      
      semester.to_csv_single
    end
  end

  describe '#get_disciplines' do
    it 'returns the disciplines associated to given semester' do
      semester = Semester.create(half: false, year: 2020)

      discipline1 = Discipline.create(name: "Banco de Dados", semester_id: 1)
      discipline2 = Discipline.create(name: "OAC", semester_id: 1)

      expect(semester.get_disciplines).to eq([discipline1, discipline2])
    end
  end

  describe '.find_by_id' do
    it 'returns the semesters by the specified id' do
      semester1 = Semester.create(half: false, year: 2020)
      semester2 = Semester.create(half: true, year: 2020)

      expect(Semester.find_by_id(2)).to eq(semester2)
    end
  end
end
