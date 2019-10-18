class RecurrenceForm
  include ActiveModel::Model

  FIELDS = %i[every day month hour min total custom_name start_number].freeze
  attr_accessor :happening, :recurrence
  attr_accessor(*FIELDS)

  def initialize(*attr)
    super
    return if every.to_s == 'onetime'

    month = nil if month.blank?
    @recurrence = Montrose::Recurrence.new(
      every: every,
      day: day,
      month: month,
      at: "#{hour.to_i}:#{min.to_i}",
    )
  end

  def preview
    return [] unless @recurrence

    @recurrence.take total.to_i
  end

  def _get_name(index)
    m = Mustache.new
    message = m.render(custom_name, number: start_number.to_i + index)
    message
  end

  def _remove_old_same_events
    same = @happening.club.happenings.where(recurrence: @happening.recurrence).where.not(id: @happening.id)
    same.destroy_all
  end

  def save
    _remove_old_same_events
    # TODO: warning for existing
    @happening.recurrence = @recurrence
    @happening.save!
    preview.each_with_index do |new_date, index|
      clone = happening.dup
      clone.recurrence = @happening.recurrence
      duration = clone.end_date - clone.start_date
      clone.start_date = new_date
      clone.end_date = clone.start_date + duration
      clone.name = _get_name(index) if custom_name.present?
      clone.save!
      happening.discipline_happenings.each do |discipline_happening|
        clone_discipline_happening = discipline_happening.dup
        clone_discipline_happening.happening = clone
        clone_discipline_happening.start_time = new_date
        clone_discipline_happening.save!
      end
    end
    true
  end
end
