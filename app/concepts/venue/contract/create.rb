module Venue::Contract
  class Create < Reform::Form
    FIELDS = %i[name latitude longitude address city].freeze
    FIELDS.each do |field|
      property field
    end

    validation do
      required(:name).filled
    end
  end
end
