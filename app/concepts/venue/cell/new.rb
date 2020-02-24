module Venue::Cell
  class New < Trailblazer::Cell
    include ActionView::Helpers::TranslationHelper
    include BootstrapForm::ActionViewExtensions::FormHelper

    # it already includes  ActionView::Helpers::FormHelper
    # and include ::Cell::RailsExtensions::HelpersAreShit
    # https://github.com/trailblazer/cells-rails/blob/master/lib/cell/railtie.rb#L49
    # include ActionView::RecordIdentifier
    # include ActionView::Helpers::FormOptionsHelper
    # include SimpleForm::ActionViewExtensions::FormHelper
  end
end
