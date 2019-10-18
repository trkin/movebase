class HappeningsForClubDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'happenings.id': { hide: true },
      'happenings.start_date': {},
      'venues.name': { title: Venue.model_name.human },
      'happenings.name': {},
    }
  end

  def all_items
    @club = Club.find @view.params[:id]
    @club.happenings.includes(:venue).references(:venue).order(:start_date)
  end

  def rows(filtered)
    filtered.map do |happening|
      link = if @view.request.controller_class.parent_name == 'Admin'
               @view.link_to(happening.name, @view.admin_happening_path(happening))
             else
               @view.link_to(happening.name, @view.happening_path(happening))
             end
      [
        happening.id,
        happening.start_date,
        happening.venue.name,
        link,
      ]
    end
  end
end
