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
    CSV.generate(headers: true, col_sep: ";") do |csv|
      Semester.all_iter(csv)
    end
  end

  def self.all_iter(csv)
    Semester.all.each { |semester| semester.to_csv(csv) }
  end

  def to_csv(csv)
    self.send_csv(csv)
    self.get_disciplines.to_csv(csv)
  end

  def to_csv_no_param
    csv = CSV.generate(headers: true, col_sep: ";") do |csv|
      self.send_csv(csv)
      self.get_disciplines.to_csv(csv)
    end
  end

  def send_csv(csv)
    csv << [self.to_s] + (self.get_disciplines.empty? ? ["Sem disciplinas."] : [])
  end

  def get_disciplines
    Discipline.where(semester_id: self.id)
  end

  def self.find_by_id(id) 
    find(id)
  end

end
