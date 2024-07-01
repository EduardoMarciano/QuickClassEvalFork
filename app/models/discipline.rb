class Discipline < ApplicationRecord
  has_many :forms

  def name_detailed
    "#{self[:code]} - #{self[:name]} #{Semester.find(self[:semester_id])}"
  end

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

  def self.all_disciplines_info(email, admin_user)
    disciplines_info = []
    disciplines = get_disciplines(email, admin_user)

    disciplines.each do |discipline|
      add_discipline_info(discipline, disciplines_info)
    end
    disciplines_info
  end

  def self.all_disciplines_with_eval_info(email, admin_user)
    disciplines_info = []
    disciplines = get_disciplines(email, admin_user)

    disciplines.where(id: Form.distinct.pluck(:discipline_id)).each do |discipline|
      add_discipline_info(discipline, disciplines_info)
    end
    disciplines_info
  end

  def self.get_disciplines(email, admin_user)
    admin_user ? Discipline.all : Discipline.where(code: StudentDiscipline.where(student_email: email).pluck(:discipline_code))
  end

  def self.add_discipline_info(discipline, disciplines_info)
    professor = Professor.find_by_registration(discipline.professor_registration)
    semester = Semester.find_by_id(discipline.semester_id)
    info = discipline.professor_and_semester_info(discipline, professor, semester)

    disciplines_info << info.merge(discipline_name: discipline.name, id: discipline.id)
  end 

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

  def self.to_csv(csv, line)
    all.each do |discipline|
      discipline.to_csv(csv, line.dup)
    end
  end

  def to_csv(csv, line)
    line << "#{code} - #{name}"
    self.forms.to_csv(csv, line)
  end

  def do_headers(csv)
    max_questions = self.forms.joins(:questions).group('id').order('COUNT(questions.id) DESC').limit(1).count('questions.id').first
    question_answers = %w[Questão Respostas] * (max_questions.nil? ? 0 : max_questions.last)

    csv << %w[Template] + question_answers
  end

  def to_csv_single
    CSV.generate(headers: true, col_sep: "; ") do |csv|
      line = []

      self.do_headers(csv)
      self.forms.to_csv(csv, line)
    end
  end

end
