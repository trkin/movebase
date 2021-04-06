class ClubsDatatable < BaseDatatable
  def columns
    {
      'clubs.id': {hide: true},
      'clubs.name': {},
      'venues.name': {title: Venue.model_name.human},
      'activities.name': {title: Activity.model_name.human(count: 2), search: false, order: false},
    }
  end

  def rows(filtered)
    filtered.map do |club|
      link = if @view.request.controller_class.module_parent_name == 'Admin'
               @view.link_to(club.name, @view.admin_club_path(club))
             else
               @view.link_to(club.name, @view.club_path(club))
             end
      [
        club.id,
        link,
        club.venue.name,
        club.activities.map(&:name).to_sentence,
      ]
    end
  end

  def all_items
    Club.all.joins(:venue)
  end
end
