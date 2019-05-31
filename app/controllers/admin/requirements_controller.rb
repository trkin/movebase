class Admin::RequirementsController < Admin::BaseController
  before_action :_set_requirement, except: %i[index new create]

  def index
    @requirements = Requirement.all
  end

  def show; end

  def new
    @requirement = Requirement.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  # JS
  def create
    @requirement = Requirement.new
    update_and_render_or_redirect_in_js @requirement, _requirement_params, ->(id) { admin_requirement_path(id) }
  end

  # JS
  def update
    update_and_render_or_redirect_in_js @requirement, _requirement_params, admin_requirement_path(@requirement)
  end

  def destroy
    @requirement.destroy!
    redirect_to admin_requirements_path, notice: helpers.t_notice('successfully_deleted', Requirement)
  end

  def _set_requirement
    @requirement = Requirement.find params[:id]
  end

  def _requirement_params
    params.require(:requirement).permit(
      *Requirement::FIELDS
    )
  end
end
