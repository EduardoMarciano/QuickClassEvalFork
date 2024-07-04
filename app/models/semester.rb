class Semester < ApplicationRecord
  validates :half, uniqueness: { scope: :year }
  has_many :forms
  has_many :templates

  def to_s
    "#{half ? '2' : '1'}-#{year}"
  end

  def self.next_semester_id
    latest_semester = order(id: :desc).first

    half, year = Semester.get_half_year(latest_semester)

    create_new_semester(half, year)
  end

  def self.get_half_year(latest_semester)
    half = count < 1 ? false : !latest_semester.half
    year = !(count >= 1) ? 2020 : latest_semester.year + (half && 0 || 1)

    return half, year
  end

  def self.create_new_semester(half, year)
    new_semester = create(half:, year:)
    new_semester.id
  end

  def self.current_semester
    latest_semester = order(id: :desc).first
    if latest_semester
      half = latest_semester.next_half
      "#{latest_semester.year}.#{half && 1 || 2}."
    else
      'Sem semestre cadastrado.'
    end
  end

  def next_half
    !self.half
  end

  def self.current_semester_id
    latest_semester = order(id: :desc).first
    return latest_semester.id if latest_semester

    latest_semester
  end

  def self.to_csv
    CSV.generate(headers: true, col_sep: "; ") do |csv|
      do_headers(csv, Discipline.all, true)
      each_csv(csv)
    end
  end

  def self.do_headers(csv, disciplines, flag)
    max_questions = Form.where(discipline_id: disciplines).joins(:questions).group('id').order('COUNT(questions.id) DESC').limit(1).count('questions.id').first
    question_answers = %w[Questão Respostas] * (max_questions.nil? ? 0 : max_questions.last)

    csv << (flag ? %w[Semestre Disciplina Template] : %w[Disciplina Template]) + question_answers
  end

  def self.each_csv(csv)
    Semester.all.each { |semester| semester.to_csv(csv) }
  end

  def to_csv(csv)
    line = [self.to_s]
    self.get_disciplines.to_csv(csv, line.dup)
  end

  def to_csv_single
    CSV.generate(headers: true, col_sep: "; ") do |csv|
      disciplines = self.get_disciplines
      line = []

      Semester.do_headers(csv, disciplines, false)
      disciplines.to_csv(csv, line)
    end
  end

  def get_disciplines
    Discipline.where(semester_id: id)
  end

  def self.find_by_id(id) 
    find(id)
  end

end
