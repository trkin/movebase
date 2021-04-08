class Admin::DisciplineAssociationsController < Admin::BaseController
  before_action :_set_discipline, only: %i[new create]
  before_action :_set_discipline_association, except: %i[new create]

  def new
    @discipline_association = @discipline.discipline_associations.new
    render partial: 'form', layout: false
  end

  def create
    @discipline_association = @discipline.discipline_associations.new
    update_and_render_or_redirect_in_js \
      @discipline_association, _discipline_association_params, lambda { |discipline_association|
        if discipline_association.similar?
          DisciplineAssociation.create! discipline:
            @discipline_association.associated, associated:
            @discipline_association.discipline, kind: :similar
        end
        admin_discipline_path(@discipline)
      }
  end

  def destroy
    @discipline_association.destroy!
    redirect_to \
      admin_discipline_path(@discipline_association.discipline),
      notice: helpers.t_notice('successfully_deleted', DisciplineAssociation)
  end

  def _discipline_association_params
    params.require(:discipline_association).permit(
      :kind, :associated_id
    )
  end

  def _set_discipline
    @discipline = Discipline.find params[:discipline_id]
  end

  def _set_discipline_association
    @discipline_association = DisciplineAssociation.includes(:discipline).find params[:id]
  end
end
