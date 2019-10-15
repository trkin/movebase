class RecurrenceForm
  include ActiveModel::Model

  FIELDS = %i[every day month hour min total].freeze
  attr_accessor :happening
  attr_accessor(*FIELDS)

  def initialize(*attr)
    super
    @valid = true
    month = nil if month.blank?
    r = if every.to_s == 'onetime'
          nil
        else
          Montrose::Recurrence.new(
            every: every,
            day: day,
            month: month,
            at: "#{hour.to_i}:#{min.to_i}",
          )
        end
    @happening.recurrence = r
  end

  def preview
    return [] unless @happening.recurrence

    @happening.recurrence.take total.to_i
  end

  def save
    # TODO: warning for existing
    #       old occurences should be removed
    @happening.save!
    preview.each do |new_date|
      clone = happening.dup
      clone.recurrence = @happening.recurrence
      duration = clone.end_date - clone.start_date
      clone.start_date = new_date
      clone.end_date = clone.start_date + duration
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