class HappeningsForActivityNamesDatatable < BaseDatatable
  def columns
    {
      'happenings.id': {hide: true},
      'happenings.name': {},
      'happenings.start_date': {},
      'venues.name': {title: Venue.model_name.human},
      'clubs.name': {title: Club.model_name.human},
      'clubs.id': {hide: true},
    }
  end

  # use activities as params since we need to marketing usage
  def activities
    return [] if @view.params[:activity_names].blank?

    names_array = @view.params[:activity_names]
    names_array = names_array.values if names_array.respond_to? :values
    Activity.i18n.where name: names_array
  end

  def all_items
    all = Happening.left_outer_joins(discipline_happenings: {discipline: {activities_disciplines: :activity}})
    all = all.where(discipline_happenings: {disciplines: {activities_disciplines: {activity: activities}}}) if activities.present?
    all = all.joins(:club, :venue)
    all = all.order(:start_date)
    all.distinct
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
        @view.link_to(happening.name, @view.happening_path(happening)),
        I18n.l(happening.start_date, format: :long_with_week),
        happening.venue.name,
        link_to_club,
        happening.club.id,
      ]
    end
  end
end
