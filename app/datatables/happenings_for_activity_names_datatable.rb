class HappeningsForActivityNamesDatatable < BaseDatatable
  def columns
    {
      'happenings.id': { hide: true },
      'happenings.name': {},
      'happenings.start_date': {},
      'venues.name': { title: Venue.model_name.human },
      'clubs.name': { title: Club.model_name.human },
      'disciplines.name': { title: Discipline.model_name.human(count: 2) },
      'clubs.id': { hide: true },
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
    all = Happening
      .left_outer_joins(discipline_happenings: { discipline: { activities_disciplines: :activity } })
      .joins(:club, :venue)
      .order(:start_date)
    if activities.present?
      all = all.where(discipline_happenings: { disciplines: { activities_disciplines: { activity: activities } } })
    end
    all = all.where('happenings.start_date >= ?', Time.zone.today)
    all.distinct
  end

  def rows(filtered)
    filtered.map do |happening|
      disciplines = happening.discipline_happenings.limit(3).map(&:full_name)
        .to_sentence
      [
        happening.id,
        @view.link_to(happening.name, @view.happening_path(happening)),
        I18n.l(happening.start_date, format: :long_with_week),
        happening.venue.name,
        happening.club.name,
        disciplines,
        happening.club.id,
      ]
    end
  end
end
