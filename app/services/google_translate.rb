require 'google/cloud/translate/v2'

class GoogleTranslate
  attr_reader :sentence, :from_locale, :to_locale

  def initialize(sentence, from_locale:, to_locale:)
    @sentence = sentence
    @from_locale = from_locale
    @to_locale = to_locale
  end

  def perform
    if from_locale.to_s == 'sr' && to_locale.to_s == 'sr-latin'
      sentence.to_lat
    elsif from_locale.to_s == 'sr-latin' && to_locale.to_s == 'sr'
      sentence.to_cyr
    else
      client = Google::Cloud::Translate::V2.new
      translation = client.translate sentence, from: from_locale, to: to_locale
      translation.text
    end
  rescue Google::Cloud::InvalidArgumentError => e
    # byebug
    raise e
  end
end
