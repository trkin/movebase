class AddHappeningFromLinkForm
  include ActiveModel::Model
  FIELDS = %i[url discipline_id].freeze

  attr_accessor :happening, *FIELDS

  validates(*FIELDS, presence: true)

  def save
    return false unless valid?
    return false if _already_proccessed?

    result = BuildHappeningFromLink.new(url, discipline_id).perform
    @happening = result.data.happening
    if result.success?
      true
    else
      errors.add(:url, result.message)
      false
    end
  end

  def _already_proccessed?
    link = Link.find_by(url: url)
    return false if link.blank?

    # TODO: add escaped javascript
    _link_to_link = ActionController::Base.helpers.link_to(
      Link.model_name.human,
      Rails.application.routes.url_helpers.link_path(I18n.locale, link)
    )
    errors.add :url, I18n.t('errors.messages.taken') # ActionController::Base.helpers.escape_javascript link_to_link}"
    true
  end
end
