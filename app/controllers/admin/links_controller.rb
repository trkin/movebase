class Admin::LinksController < Admin::BaseController
  before_action :_set_link, except: %i[index search new create]

  def index
    @datatable = LinksDatatable.new view_context
  end

  def search
    render json: LinksDatatable.new(view_context)
  end

  def show; end

  def new
    @link = Link.new
    render partial: 'form', layout: false
  end

  def edit
    render partial: 'form', layout: false
  end

  def create
    @link = Link.new

    update_and_render_or_redirect_in_js @link, _link_params, ->(id) { link_path(id) }
  end

  def update
    update_and_render_or_redirect_in_js @link, _link_params, link_path(@link)
  end

  def destroy
    @link.destroy!
    redirect_to admin_links_path, notice: helpers.t_notice('successfully_deleted', Link)
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
