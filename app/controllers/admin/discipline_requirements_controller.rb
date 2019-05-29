class Admin::DisciplineRequirementsController < Admin::BaseController
  before_action :_set_discipline, only: %i[new create]
  before_action :_set_discipline_requirement, except: %i[new create]

  def new
    @discipline_requirement = @discipline.discipline_requirements.new
    render partial: 'form', layout: false
  end

  def create
    @discipline_requirement = @discipline.discipline_requirements.new
    update_and_render_or_redirect_in_js \
      @discipline_requirement, _discipline_requirement_params, admin_discipline_path(@discipline)
  end

  def destroy
    @discipline_requirement.destroy!
    redirect_to \
      admin_discipline_path(@discipline_requirement.discipline),
      notice: helpers.t_notice('successfully_deleted', DisciplineRequirement)
  end

  def _discipline_requirement_params
    params.require(:discipline_requirement).permit(
      :requirement_id
    )
  end

  def _set_discipline
    @discipline = Discipline.find params[:discipline_id]
  end

  def _set_discipline_requirement
    @discipline_requirement = DisciplineRequirement.includes(:discipline).find params[:id]
  end
end
