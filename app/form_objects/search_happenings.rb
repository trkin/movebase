class SearchHappenings
  include ActiveModel::Model
  attr_accessor :venue_id, :activity_id

  validates :venue_id, :activity_id, presence: true

  # all results are grouped by happening

  def results
    return @results if @results.present?

    results =
      Happening
      .left_outer_joins(discipline_happenings: { discipline: :activity })
      .where(discipline_happenings: { disciplines: { activity: activity.self_and_used_in_activities } })
      .distinct

    @results = results
  end

  def activity
    @activity ||= Activity.find_by(id: activity_id) || Activity.first
  end

  def venue
    @venue ||= Venue.find_by(id: venue_id) || Venue.first
  end

  def all_cities
    Venue.cities.select(
      <<~SQL
        venues.*,
        (
          SELECT COUNT(happenings.id) FROM happenings
          WHERE venue_id = venues.id
        ) AS happening_count
      SQL
    ).order(happening_count: :desc)
  end

  def all_activities
    Activity.all
  end
end
