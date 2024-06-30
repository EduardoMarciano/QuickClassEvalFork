require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Discipline, type: :model do

  describe '#name_detailed' do
    it 'returns some info about the discipline' do
      semester = Semester.create(half: false, year: 2020)
      discipline = Discipline.create(name: "Math", code: "MTH101", professor_registration: "12345", semester_id: 1)

      expect(discipline.name_detailed).to eq("MTH101 - Math #{semester}")
    end
  end

  describe '.create_by_json' do
    let(:data) { { "name" => "Math", "code" => "MTH101", "professor_registration" => "12345" } }
    let(:semester_id) { 1 }

    it 'creates a new discipline with valid data' do
      discipline = Discipline.create_by_json(data, semester_id)

      expect(discipline.name).to eq("Math")
      expect(discipline.code).to eq("MTH101")
      expect(discipline.professor_registration).to eq("12345")
      expect(discipline.semester_id).to eq(semester_id)
    end   
  end

  describe '#.all_disciplines_info' do
    context 'user is admin' do
      it 'gets info from all specific disciplines' do
        Semester.create(half: false, year: 2020)
        Professor.create(registration_number: "12345", name: "MARISTELA TERTO DE HOLANDA", department_code: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")
        Professor.create(registration_number: "33333", name: "DANIEL DE PAULA PORTO", department_code: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")

        Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
        Discipline.create(name: "ES", code: "CIC0000", professor_registration: "33333", semester_id: 1)

        disciplines_info = Discipline.all_disciplines_info(nil, true)

        expect(disciplines_info).to eq([{:discipline_name=>"OAC",
                                         :professor_name=>"MARISTELA TERTO DE HOLANDA",
                                         :professor_department_code=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
                                         :semester_name=>"2020.1.",
                                         :form_id=>"",
                                         :id=>1},
                                        {:discipline_name=>"ES",
                                         :professor_name=>"DANIEL DE PAULA PORTO",
                                         :professor_department_code=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
                                         :semester_name=>"2020.1.",
                                         :form_id=>"",
                                         :id=>2}])
      end
    end

    context 'user is student' do
      let(:email) {'"teste@gmail.com"'}
      it 'returns all disciplines they are registered' do
        Semester.create(half: false, year: 2020)
        Professor.create(registration_number: "12345", name: "MARISTELA TERTO DE HOLANDA", department_code: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")
        Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)

        StudentDiscipline.create(student_email: email, discipline_code: "CIC1001", semester_id: 1)

        disciplines_info = Discipline.all_disciplines_info(email, false)

        expect(disciplines_info).to eq([{:discipline_name=>"OAC",
                                         :professor_name=>"MARISTELA TERTO DE HOLANDA",
                                         :professor_department_code=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
                                         :semester_name=>"2020.1.",
                                         :form_id=>"",
                                         :id=>1}])
      end
    end
  end

  describe '#.all_disciplines_with_eval_info' do
    context 'user is admin' do
      it 'gets info from all specific disciplines from its forms' do
        Semester.create(half: false, year: 2020)
        Professor.create(registration_number: "12345", name: "MARISTELA TERTO DE HOLANDA", department_code: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")
        Template.create()

        Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
        Form.create(template_id: 1, discipline_id: 1)

        disciplines_info = Discipline.all_disciplines_with_eval_info(nil, true)

        expect(disciplines_info).to eq([{:discipline_name=>"OAC",
                                         :professor_name=>"MARISTELA TERTO DE HOLANDA",
                                         :professor_department_code=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
                                         :semester_name=>"2020.1.",
                                         :form_id=>1,
                                         :id=>1}])
      end
    end

    context 'user is student' do
      let(:email) {'"teste@gmail.com"'}
      it 'returns all disciplines they are registered from its forms' do
        Semester.create(half: false, year: 2020)
        Professor.create(registration_number: "12345", name: "MARISTELA TERTO DE HOLANDA", department_code: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")
        Template.create()
        
        Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
        Form.create(template_id: 1, discipline_id: 1)

        StudentDiscipline.create(student_email: email, discipline_code: "CIC1001", semester_id: 1)

        disciplines_info = Discipline.all_disciplines_with_eval_info(email, false)

        expect(disciplines_info).to eq([{:discipline_name=>"OAC",
                                         :professor_name=>"MARISTELA TERTO DE HOLANDA",
                                         :professor_department_code=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
                                         :semester_name=>"2020.1.",
                                         :form_id=>1,
                                         :id=>1}])
      end
    end
  end

  describe '.to_csv' do
    it 'converts the each discipline to a CSV' do
      Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
      Discipline.create(name: "ES", code: "CIC0000", professor_registration: "33333", semester_id: 1)
      
      CSV.generate(headers: true, col_sep: ";") do |csv|
        Discipline.to_csv(csv)
      end
    end
  end

  describe '#to_csv_no_params' do
    it 'converts the semester to a CSV' do
      discipline = Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)
      discipline.to_csv_no_param
    end
  end

  describe '#to_csv' do
    it 'converts the discipline to a CSV' do
      discipline = Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)

      CSV.generate(headers: true, col_sep: ";") do |csv|
        discipline.to_csv(csv)
      end
    end
  end

  describe '#send_csv' do
    it 'sends the parameters to the csv' do
      discipline = Discipline.create(name: "OAC", code: "CIC1001", professor_registration: "12345", semester_id: 1)

      CSV.generate(headers: true, col_sep: ";") do |csv|
        discipline.send_csv(csv)

        expect(csv.headers).to eq(["CIC1001 - OAC", "Sem formulários."])
      end
    end   
  end

end
