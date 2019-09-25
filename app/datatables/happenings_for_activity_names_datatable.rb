class HappeningsForActivityNamesDatatable < BaseDatatable
  def columns
    {
      'clubs.name': { title: Club.model_name.human },
      'venues.name': { title: Venue.model_name.human },
      'happenings.name': {},
      'happenings.start_date': {},
    }
  end

  # use activities as params since I do not want to write sql for
  # activity.self_and_used_in_activities
  # and we should extract this info for marketing usage
  def activities
    Activity.i18n.where name: @view.params[:activity_names]
  end

  def self_and_used_in_activities
    activities.map(&:self_and_used_in_activities).flatten
  end

  def all_items
    Happening
      .left_outer_joins(discipline_happenings: { discipline: :activity })
      .where(discipline_happenings: { disciplines: { activity: self_and_used_in_activities } })
      .joins(:club, :venue)
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
        link_to_club,
        happening.venue.name,
        @view.link_to(happening.name, @view.happening_path(happening)),
        happening.start_date
      ]
    end
  end
end
