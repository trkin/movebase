class ClubsDatatable < BaseDatatable
  def columns
    {
      'clubs.id': { hide: true },
      'clubs.name': {},
      'venues.name': { title: Venue.model_name.human },
      'clubs.website': {},
      'activities.name': { title: Activity.model_name.human(count: 2), search: false, order: false },
      '': { title: @view.t('actions') },
    }
  end

  def rows(filtered)
    filtered.map do |club|
      actions = @view.link_to(@view.t_crud('show', Club), @view.club_path(club))
      [
        club.id,
        club.name,
        club.venue.name,
        club.website,
        club.activities.map(&:name).to_sentence,
        actions,
      ]
    end
  end

  def all_items
    Club.all.joins(:venue)
  end
end
