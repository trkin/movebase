class HappeningsForDisciplinesDatatable < BaseDatatable
  def columns
    {
      'happenings.id': { hide: true },
      'happenings.name': {},
      'happenings.start_date': {},
      'venues.name': { title: Venue.model_name.human },
      'clubs.name': { title: Club.model_name.human },
      'clubs.id': { hide: true },
    }
  end

  def disciplines
    Discipline.where id: @view.params[:discipline_ids]
  end

  def similar_disciplines
    disciplines
      .map(&:similar_disciplines)
      .flatten
      .uniq
      .reject { |discipline| disciplines.include? discipline }
  end

  def consists_of_and_used_in_disciplines
    (
      disciplines
        .map(&:consists_of_disciplines)
        .flatten
        .uniq
        .to_a +
      disciplines
        .map(&:used_in_disciplines)
        .flatten
        .uniq
        .to_a
    )
      .reject { |discipline| disciplines.include? discipline }
  end

  def all_items
    all = Happening.left_outer_joins(discipline_happenings: :discipline)
    all = all.where(discipline_happenings: { discipline: disciplines }) if disciplines.present?
    all = all.joins(:club, :venue)
    all = all.order(:start_date)
    all.distinct
  end

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
