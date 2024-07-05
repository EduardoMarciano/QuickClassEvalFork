# == SemesterController
#
# Controls routes for semesters. 
#
class SemestersController < ApplicationController

  ##
  # Controls route "/semesters" and defines CSV generation by "/semesters.csv" 
  # Does not have a display.
  #
  def index
    if Semester.current_semester_id
      respond_to do |format|
        format.html do
          redirect_to manager_path 
        end

        format.csv do 
          send_data Semester.to_csv, filename: "resultados_semestres.csv"
        end
      end
    else
      handle_no_semester_error
    end
  end

  ##
  # Controls route "/semester/current" and defines CSV generation by "/semesters/current.csv"
  # Does not have display.
  #
  def show
    if Semester.current_semester_id
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
      handle_no_semester_error
    end
  end

  private

  ##
  # Flashes an error message when user attempts to export CSV without a semester registered.
  #
  # Returns:
  #   NilClass
  #
  def handle_no_semester_error
    flash[:error] = "Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema."
    redirect_to manager_path
  end
end
