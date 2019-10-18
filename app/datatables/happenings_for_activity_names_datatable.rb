class HappeningsForActivityNamesDatatable < BaseDatatable
  def columns
    {
      'happenings.id': { hide: true },
      'happenings.start_date': {},
      'venues.name': { title: Venue.model_name.human },
      'clubs.name': { title: Club.model_name.human },
      'clubs.id': { hide: true },
      'happenings.name': {},
    }
  end

  # use activities as params since we need to marketing usage
  def activities
    return [] if @view.params[:activity_names].blank?

    Activity.i18n.where name: @view.params[:activity_names]
  end

  def all_items
    all = Happening.left_outer_joins(discipline_happenings: { discipline: :activity })
    all = all.where(discipline_happenings: { disciplines: { activity: activities } }) if activities.present?
    all = all.joins(:club, :venue)
    all = all.order(:start_date)
    all = all.distinct
    all
  end

  # def as_json(_ = nil)
  #   byebug
  #   super
  # end

  def rows(filtered)
    filtered.map do |happening|
      link_to_club = if happening.club.sport_organization?
                       @view.link_to(happening.club.name, @view.club_path(happening.club))
                     else
                       happening.club.name
                     end
      [
        happening.id,
        happening.start_date,
        happening.venue.name,
        link_to_club,
        happening.club.id,
        @view.link_to(happening.name, @view.happening_path(happening)),
      ]
    end
  end
end
