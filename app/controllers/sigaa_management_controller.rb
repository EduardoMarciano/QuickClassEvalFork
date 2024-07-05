# Controller responsible for managing SIGAA data import and updates.
#
# This controller provides methods to import and update data from SIGAA, as well as to send access keys to students.
#
class SigaaManagementController < ApplicationController

  # Imports data from SIGAA for the next semester.
  #
  # Calls methods to import professors, class members, disciplines, and class members' disciplines.
  # Sets a success flash message and redirects to the manager path.
  def import_sigaa_data
    semester_id = Semester.next_semester_id
    import_professors
    import_class_members
    import_disciplines(semester_id)
    import_class_members_disciplines(semester_id)
    flash[:success] = "Dados importados com sucesso!"
    redirect_to manager_path
    return
  end

  # Updates data from SIGAA for the current semester.
  #
  # If the current semester ID is available, it calls methods to import professors, class members,
  # disciplines, and class members' disciplines. Sets a success flash message on success, or an error
  # flash message if no semester is registered. Redirects to the manager path.
  def update_sigaa_data
    semester_id = Semester.current_semester_id
    if semester_id
      import_professors
      import_class_members
      import_disciplines(semester_id)
      import_class_members_disciplines(semester_id)
      flash[:success] = "Dados atualizados com sucesso!"
    else
      flash[:error] = "Não é possível atualizar os dados sem um semestre cadastrado, importe os dados do sistema."
    end
    redirect_to manager_path
  end  

  # Sends access keys to all students imported from SIGAA.
  #
  # Calls the method to send available sign-up keys and sets a success flash message.
  # Redirects to the manager path.
  def send_email_availables_sign_up
    SignUpAvailable.send_keys_availables_sign_up
    flash[:success] = "Chave de acesso enviada para todos os Alunos Importados do SIGAA."
    redirect_to manager_path
    return
  end

  private

  # Imports professors from a JSON file.
  #
  # Reads data from 'db/data/professors.json' and creates professors in the database.
  def import_professors
    json_file_path = Rails.root.join('db', 'data', 'professors.json')
    json_data = JSON.parse(File.read(json_file_path))

    json_data.each do |professor_data|
      Professor.create_by_json(professor_data)
    end
  end

  # Imports disciplines for the given semester from a JSON file.
  #
  # Reads data from 'db/data/discipline.json' and creates disciplines in the database.
  #
  # @param semester_id [Integer] the ID of the semester to import disciplines for
  def import_disciplines(semester_id)
    json_file_path =  Rails.root.join('db', 'data', 'discipline.json')
    json_data = JSON.parse(File.read(json_file_path))

    json_data.each do |discipline_data|
      Discipline.create_by_json(discipline_data, semester_id)
    end
  end

  # Imports class members from a JSON file.
  #
  # Reads data from 'db/data/class_members.json' and creates sign-up entries for students in the database.
  def import_class_members
    json_file_path = Rails.root.join('db', 'data', 'class_members.json')
    json_data = JSON.parse(File.read(json_file_path))

    json_data.each do |student_data|
      SignUpAvailable.create_by_json(student_data["email"])
    end
  end
  
  # Imports class members' disciplines for the given semester from a JSON file.
  #
  # Reads data from 'db/data/students_class.json' and creates student-discipline associations in the database.
  #
  # @param semester_id [Integer] the ID of the semester to import class members' disciplines for
  def import_class_members_disciplines(semester_id)
    json_file_path = Rails.root.join('db', 'data', 'students_class.json')
    json_data = JSON.parse(File.read(json_file_path))
  
    json_data.each do |class_member_data|
      email = class_member_data['email']
      code = class_member_data['code']
  
      unless StudentDiscipline.exists?(student_email: email, discipline_code: code, semester_id: semester_id)
        StudentDiscipline.create!(student_email: email, discipline_code: code, semester_id: semester_id)
      end      
    end
  end
end
