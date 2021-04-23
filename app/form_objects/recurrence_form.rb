class RecurrenceForm
  include ActiveModel::Model

  FIELDS = %i[every month total custom_name start_number existing_update].freeze +
           [day: []]
  attr_accessor :happening, :recurrence, *(FIELDS.map { |field| field.is_a?(Symbol) ? field : field.keys.first})

  def initialize(*attr)
    super
    return if every.nil? || every.to_s == 'onetime'

    self.total = 1 if total.to_i.zero?
    if every.blank? && @happening.recurrence.present?
      self.every = @happening.recurrence.to_h[:every]
      self.day = @happening.recurrence.to_h[:day]
      self.month = @happening.recurrence.to_h[:month]
    end
    self.month = nil if month.to_i.zero?
    self.day = [day].reject(&:blank?)
    self.existing_update = :future unless existing_update.present?
    @recurrence = Montrose::Recurrence.new(
      every: every,
      day: day,
      month: month,
    )
  end

  def take_dates
    return [] unless @recurrence

    @recurrence.take(total.to_i).map(&:to_date)
  end

  def get_name(index)
    m = Mustache.new
    message = m.render(custom_name.to_s, number: start_number.to_i + index)
    message
  end

  def all_existing_events_except_self
    @happening
      .club
      .happenings
      .where(recurrence: @happening.recurrence)
      .where.not(id: @happening.id)
  end

  def existing_in_the_future
    all_existing_events_except_self
      .where(start_date: Date.current..)
  end

  def remove_old_same_events
    if existing_update == 'future'
      existing_in_the_future.destroy_all
    elsif existing_update == 'all'
      all_existing_events_except_self.destroy_all
    end
  end

  def save
    remove_old_same_events if existing_update.present?
    # TODO: warning for existing
    @happening.recurrence = @recurrence
    @happening.save!
    take_dates.each_with_index do |new_date, index|
      clone = happening.dup
      clone.recurrence = @happening.recurrence
      duration = clone.end_date - clone.start_date
      clone.start_date = new_date
      clone.end_date = clone.start_date + duration
      clone.name = get_name(index) if custom_name.present?
      clone.save!
      happening.discipline_happenings.each do |discipline_happening|
        clone_discipline_happening = discipline_happening.dup
        clone_discipline_happening.happening = clone
        clone_discipline_happening.save!
      end
    end
    true
  end
end
