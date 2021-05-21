class HappeningsForClubDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'happenings.id': { hide: true },
      'happenings.name': {},
      'happenings.start_date': {},
      'venues.name': { title: Venue.model_name.human },
    }
  end

  def all_items
    @club = Club.find @view.params[:id]
    if @club.happenings.present?
      @club.happenings.includes(:venue).references(:venue).order(:start_date)
    else
      @club.secondary_happenings.includes(:venue).references(:venue).order(:start_date)
    end
  end

  def rows(filtered)
    filtered.map do |happening|
      link = if @view.request.controller_class.module_parent_name == 'Admin'
               @view.link_to(happening.name, @view.admin_happening_path(happening))
             else
               @view.link_to(happening.name, @view.happening_path(happening))
             end
      [
        happening.id,
        link,
        I18n.l(happening.start_date, format: :long_with_week),
        happening.venue.name,
      ]
    end
  end
end
