class LinksController < ApplicationUserController
  before_action :_set_link, except: %i[index search new create]

  def index
    @datatable = LinksDatatable.new view_context
  end

  def search
    render json: LinksDatatable.new(view_context)
  end

  def show; end

  def new
    if params[:happening_id].present?
      linkable_id = params[:happening_id]
      linkable_type = 'Happening'
    elsif params[:club_id].present?
      linkable_id = params[:club_id]
      linkable_type = 'Club'
    else
      raise "do_not_know_linkable_type params=#{params}"
    end
    @link = Link.new(
      linkable_id: linkable_id,
      linkable_type: linkable_type,
    )
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @link = Link.new
    update_and_render_or_redirect_in_js @link, _link_params, nil
  end

  def update
    update_and_render_or_redirect_in_js @link, _link_params, link_path(@link)
  end

  def destroy
    @link.destroy!
    redirect_to links_path, notice: helpers.t_notice('successfully_deleted', Link)
  end

  def _set_link
    @link = Link.find(params[:id])
  end

  def _link_params
    params.require(:link).permit(
      *Link::FIELDS
    )
  end
end
