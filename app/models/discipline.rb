# == Discipline
#
# Defines and stores current and previous semesters's disciplines of the application.
#
# Attributes:
#   id: Integer, primary key
#   name: String, name of the discipline
#   code: String, unique discipline code
#   professor_registration: String, discipline professor identifier
#   semester_id: Integer, foreign key
#
# Usage:
#   discipline = Discipline.create(name: "BD", code: "CIC0097", professor_registration: "123")
#   discipline.save
#
class Discipline < ApplicationRecord
  has_many :forms

  ##
  # Defines and returns a string version of the discipline, with format:
  #   "[code] - [name] [Semester]", where Semester is the semester in which the discipline is part of.
  #
  # Returns:
  #   String
  #
  # Usage:
  #   Semester.create(half: false, year: 2020)
  #   discipline = Discipline.create(name: "BD", code: "CIC0097", professor_registration: "123", semester_id: 1)
  #   discipline.name_detailed => "CIC0097 - BD 1-2020"
  #
  def name_detailed
    "#{self[:code]} - #{self[:name]} #{Semester.find(self[:semester_id])}"
  end

  ##
  # Creates a discipline using a JSON file containing name, code and professor.
  #
  # Parameters:
  #   data - Hash
  #   semester_id - Integer
  #
  # Returns:
  #   Discipline
  #
  # Usage:
  #   Semester.create(half: false, year: 2020)
  #   Discipline.create_by_json({"name"=>"Banco de Dados", "code"=>"CIC0097", "professor_registration"=>"123"}, 1)
  #
  def self.create_by_json(data, semester_id)
    data_code = data['code']
    existing_discipline = find_by(code: data_code, semester_id:)
    return if existing_discipline

    create!(
      name: data['name'],
      code: data_code,
      professor_registration: data['professor_registration'],
      semester_id:
    )
  end

  ##
  # Gets and returns all disciplines available to user with specified email and admin permission, containing information about them.
  #
  # Parameters:
  #   email - String
  #   admin_user - TrueClass/FalseClass
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   Discpline.all_disciplines_info(logged_user.email, admin_user?)
  #
  def self.all_disciplines_info(email, admin_user)
    disciplines_info = []
    disciplines = get_disciplines(email, admin_user)

    disciplines.each do |discipline|
      add_discipline_info(discipline, disciplines_info)
    end
    disciplines_info
  end

  ##
  # Gets and returns all disciplines available to user with specified email and admin permission, containing information about them and their available forms.
  #
  # Parameters:
  #   email - String
  #   admin_user - TrueClass/FalseClass
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   Discpline.all_disciplines_with_eval_info(logged_user.email, admin_user?)
  #
  def self.all_disciplines_with_eval_info(email, admin_user)
    disciplines_info = []
    disciplines = get_disciplines(email, admin_user)

    disciplines.where(id: Form.distinct.pluck(:discipline_id)).each do |discipline|
      add_discipline_info(discipline, disciplines_info)
    end
    disciplines_info
  end

  ##
  # Returns all the disciplines available to user with specified email and admin permission.
  #
  # Parameters:
  #   email - String
  #   admin_user - TrueClass/FalseClass
  #
  # Returns:
  #   Discipline::ActiveRecord_Relation
  #
  # Usage:
  #   Discpline.get_disciplines(logged_user.email, admin_user?)
  #
  def self.get_disciplines(email, admin_user)
    admin_user ? Discipline.all : Discipline.where(code: StudentDiscipline.where(student_email: email).pluck(:discipline_code))
  end

  ##
  # Adds information of a discipline into array collection of disciplines.
  #
  # Parameters:
  #   discipline - Discipline
  #   disciplines_info - Array
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   discipline = Discipline.create(name: "BD", code: "CIC0097", professor_registration: "123")
  #   Discpline.add_disciplines_info(discipline, [])
  #
  def self.add_discipline_info(discipline, disciplines_info)
    professor = Professor.find_by_registration(discipline.professor_registration)
    semester = Semester.find_by_id(discipline.semester_id)
    info = discipline.professor_and_semester_info(discipline, professor, semester)

    disciplines_info << info.merge(discipline_name: discipline.name, id: discipline.id)
  end 

  ##
  # Returns a form for the discipline containing information about it.
  #
  # Parameters:
  #   discipline - Discipline
  #   professor - Professor
  #   semester - Semester
  #
  # Returns:
  #   Form
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   professor = Professor.create(registration_number: "123", 
  #                               name: "MARISTELA TERTO DE HOLANDA", 
  #                               department_code: "DEPTO CIÊNCIAS DA COMPUTAÇÃO",)
  #   discipline = Discipline.create(name: "BD", code: "CIC0097", professor_registration: "123", semester_id: 1)
  #   discipline.professor_and_semester_info(discipline, professor, semester)
  #
  def professor_and_semester_info(discipline, professor, semester)
    professor_name = professor&.name
    professor_department_code = professor&.department_code
    semester_name = if semester
                      "#{semester.year}.#{semester.next_half && 1 || 2}."
                    else
                      'Sem semestre cadastrado.'
                    end
    form = Form.where(discipline:).first
    {
      discipline_name: name,
      professor_name:,
      professor_department_code:,
      semester_name:,
      form_id: (form && form.id) || ''
    }
  end 

  ##
  # Parses each discipline to the given line on the csv.
  #
  # Parameters:
  #   csv - CSV
  #   line - Array
  #
  # Returns:
  #   String
  #
  def self.to_csv(csv, line)
    all.each do |discipline|
      discipline.to_csv(csv, line.dup)
    end
  end

  ##
  # Transforms the discipline to a CSV line and calls its forms csv formatting method. 
  #
  # Parameters:
  #   csv - CSV
  #   line - Array
  #
  # Returns:
  #   Array
  #
  def to_csv(csv, line)
    line << "#{code} - #{name}"
    self.forms.to_csv(csv, line)
  end

  ##
  # Creates the headers for the passed csv file, with format:
  #   "Template; {}\n"
  #
  # Parameters:
  #   csv - CSV
  #
  # Returns:
  #   csv - CSV
  #
  def do_headers(csv)
    max_questions = self.forms.joins(:questions).group('id').order('COUNT(questions.id) DESC').limit(1).count('questions.id').first
    question_answers = %w[Questão Respostas] * (max_questions.nil? ? 0 : max_questions.last)

    csv << %w[Template] + question_answers
  end

  ##
  # Transforms an individual discipline to a CSV file line and calls its forms csv formatting method.
  #
  # Returns:
  #   String
  #
  def to_csv_single
    CSV.generate(headers: true, col_sep: "; ") do |csv|
      line = []

      self.do_headers(csv)
      self.forms.to_csv(csv, line)
    end
  end

end
