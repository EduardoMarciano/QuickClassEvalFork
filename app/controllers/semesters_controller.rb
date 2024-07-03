class SemestersController < ApplicationController
  def index
    if Semester.current_semester_id

      if Form.count > 0

        respond_to do |format|
          format.html do
            redirect_to manager_path 
          end

          format.csv do 
            send_data Semester.to_csv, filename: "resultados_semestres.csv"
          end

        end
      else
        flash[:error] = "Nenhum formúlário existente para download de resultados."
        redirect_to manager_path
      end
    else
      flash[:error] = "Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema."
      redirect_to manager_path
    end
  end

  def show
    if Semester.current_semester_id
      
      if Form.count > 0

        @semester = Semester.find(Semester.current_semester_id)

        respond_to do |format|
          format.html do
            redirect_to manager_path
          end

          format.csv do 
            send_data @semester.to_csv_single, filename: "resultados_#{@semester.to_s}.csv"
          end 

        end
      else
        flash[:error] = "Nenhum formúlário existente para download de resultados."
        redirect_to manager_path
      end
    else
      flash[:error] = "Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema."
      redirect_to manager_path
    end
  end

end
