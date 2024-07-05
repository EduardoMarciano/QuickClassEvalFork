# == Semester
#
# Defines and stores current and previous semesters of the application.
#
# Attributes:
#   id: integer, primary key
#   half: TrueClass/FalseClass, first or second semester of the year
#   year: integer, current year of said semester
#
# Usage:
#   semester = Semester.create(half: false, year: 2020)
#   semester.save
#
class Semester < ApplicationRecord
  validates :half, uniqueness: { scope: :year }
  has_many :forms
  has_many :templates

  ##
  # Defines and returns a string version of the semester, with format:
  #   "[half].[year]"
  #
  # Returns:
  #   String
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   semester.to_s => "1.2020"
  #
  def to_s
    "#{half ? '2' : '1'}-#{year}"
  end

  ##
  # Creates and returns the id of the next semester on the application. If no semesters exist, default is 1.2020.
  # 
  # Returns:
  #   Integer
  #
  # Usage:
  #   Semester.next_semester_id => 1
  #
  def self.next_semester_id
    latest_semester = order(id: :desc).first

    half, year = Semester.get_half_year(latest_semester)

    create_new_semester(half, year)
  end

  ##
  # Defines and returns the next semester's half and year parameters. 
  # 
  # Parameters:
  #   latest_semester - Semester
  #
  # Returns:
  #   half - TrueClass/FalseClass
  #   year - Integer
  #
  # Usage:
  #   latest_semester = Semester.order(id: :desc).first
  #   Semester.get_half_year(latest_semester) => false, 2020
  #
  def self.get_half_year(latest_semester)
    half = count < 1 ? false : !latest_semester.half
    year = !(count >= 1) ? 2020 : latest_semester.year + (half && 0 || 1)

    return half, year
  end

  ##
  # Creates a new semester defined by the passed parameters and returns its id. 
  # 
  # Parameters:
  #   half - TrueClass/FalseClass
  #   year - Integer
  #
  # Returns:
  #   Integer
  #
  # Usage:
  #   Semester.create_new_semester(false, 2020) => 1
  #
  def self.create_new_semester(half, year)
    new_semester = create(half:, year:)
    new_semester.id
  end

  ##
  # Returns a string version of the current semester if exists.
  #
  # Returns:
  #   String
  #
  # Usage:
  #   Semester.create(half: false, year: 2020)
  #   Semester.current_semester => "2020.1"
  #
  def self.current_semester
    latest_semester = order(id: :desc).first
    if latest_semester
      half = latest_semester.next_half
      "#{latest_semester.year}.#{half && 1 || 2}."
    else
      'Sem semestre cadastrado.'
    end
  end

  ##
  # Returns the half of the next semester. If previous semester was the first, next is the second and vice versa.
  #
  # Returns:
  #   TrueClass/FalseClass
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   semester.next_half => true
  #
  def next_half
    !self.half
  end

  ##
  # Returns the id of current semester if it exists.
  #
  # Returns:
  #   Semester
  #
  # Usage:
  #   Semester.create(half: false, year: 2020)
  #   Semester.current_semester_id => 1
  #
  def self.current_semester_id
    latest_semester = order(id: :desc).first
    return latest_semester.id if latest_semester

    latest_semester
  end

  ##
  # Generates CSV object and its header, and parses each semester to a line on the csv.
  #
  # Returns:
  #   String
  #
  # Usage:
  #   Semester.to_csv => "Semestre; Disciplina; Template\n"
  #
  def self.to_csv
    CSV.generate(headers: true, col_sep: "; ") do |csv|
      do_headers(csv, Discipline.all, true)
      each_csv(csv)
    end
  end

  ##
  # Creates the headers for the passed csv file, with format:
  #   "Semestre; Disciplina; Template; {}\n"
  #
  # Parameters:
  #   csv - CSV
  #   disciplines - Discipline::ActiveRecord_Relation
  #   flag - TrueClass/FalseClass
  #
  # Returns:
  #   csv - CSV
  #
  # Usage:
  #   Semester.do_headers => "Semestre; Disciplina; Template\n"
  #
  def self.do_headers(csv, disciplines, flag)
    max_questions = Form.where(discipline_id: disciplines).joins(:questions).group('id').order('COUNT(questions.id) DESC').limit(1).count('questions.id').first
    question_answers = %w[Questão Respostas] * (max_questions.nil? ? 0 : max_questions.last)

    csv << (flag ? %w[Semestre Disciplina Template] : %w[Disciplina Template]) + question_answers
  end

  ##
  # Parses each semester into a csv file line.
  #
  # Parameters:
  #   csv - CSV
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   Semester.each_csv => ""
  #
  def self.each_csv(csv)
    Semester.all.each { |semester| semester.to_csv(csv) }
  end

  ##
  # Transforms the semester to a CSV file line and calls its disciplines csv formatting method.
  #
  # Parameters:
  #   csv - CSV
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   CSV.generate(headers: true, col_sep: "; ") do |csv|
  #     semester.to_csv(csv) => ""
  #   end
  #
  def to_csv(csv)
    line = [self.to_s]
    self.get_disciplines.to_csv(csv, line.dup)
  end

  ##
  # Transforms an individual semester to a CSV file line and calls its disciplines csv formatting method.
  #
  # Returns:
  #   String
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   semester.to_csv_single => "Disciplina; Template\n"
  #
  def to_csv_single
    CSV.generate(headers: true, col_sep: "; ") do |csv|
      disciplines = self.get_disciplines
      line = []

      Semester.do_headers(csv, disciplines, false)
      disciplines.to_csv(csv, line)
    end
  end

  ##
  # Finds and returns the collection of disciplines pertaining of the semester.
  #
  # Returns:
  #   Discipline::ActiveRecord_Relation
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   semester.get_disciplines => []
  #
  def get_disciplines
    Discipline.where(semester_id: id)
  end

  ##
  # Finds and returns the semester with the passed id.
  #
  # Parameters:
  #   id - Integer
  #
  # Returns:
  #   Semester
  #
  # Usage:
  #   semester = Semester.create(half: false, year: 2020)
  #   Semester.find_by_id(1) == semester => true
  #
  def self.find_by_id(id) 
    find(id)
  end

end
