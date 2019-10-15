class ClubsDatatable < BaseDatatable
  def columns
    {
      'clubs.id': { hide: true },
      'venues.name': { title: Venue.model_name.human },
      'clubs.website': {},
      'activities.name': { title: Activity.model_name.human(count: 2), search: false, order: false },
      'clubs.name': {},
    }
  end

  def rows(filtered)
    filtered.map do |club|
      [
        club.id,
        club.venue.name,
        club.website,
        club.activities.map(&:name).to_sentence,
        @view.link_to(club.name, @view.club_path(club)),
      ]
    end
  end

  def all_items
    Club.all.joins(:venue)
  end
end
