# == EvaluationsController
#
# Controls routes for evaluations. 
#
class EvaluationsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  ##
  # Controls route "/evaluations" and displays all forms for authenticated user.
  #
  def index
    if user_authenticated
      @disciplines_info = Discipline.all_disciplines_with_eval_info(logged_user.email, admin_user?)
      render 'index'
    else
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  ##
  # Controls route "/disciplines" and displays all disciplines for authenticated user.
  #
  def disciplines
    if user_authenticated
      @disciplines_info = Discipline.all_disciplines_info(logged_user.email, admin_user?)
      render 'disciplines'
    else
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  ##
  # Controls route "/evaluations/:id" and defines response to csv format"
  # Does not have display.
  #
  # Parameters:
  #   params[:id] - id of the defined discipline
  #
  def show
    discipline = Discipline.find(params[:id])

    respond_to do |format|
      format_do(format, discipline)
    end
  end

  ##
  # Defines CSV generation by "/evaluations/:id.csv"
  #
  # Parameters:
  #   format - *mimes
  #   discipline - Discipline
  #
  # Returns:
  #   CSV
  #
  def format_do(format, discipline)
    format.html do
      redirect_to evaluations_path
    end

    format.csv do
      send_data discipline.to_csv_single, filename: "#{discipline.name}.csv"
    end
  end
end
