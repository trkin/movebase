class AddHappeningFromLinkForm
  include ActiveModel::Model
  FIELDS = %i[link discipline_id].freeze

  attr_accessor :happening, *FIELDS

  validates(*FIELDS, presence: true)

  def save
    return false unless valid?

    result = BuildHappeningFromLink.new(link, discipline_id).perform
    if result.success?
      @happening = result.data.happening
      true
    else
      errors.add(:link, result.message)
      false
    end
  end
end
