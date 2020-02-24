module Venue::Operation
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Venue, :new)
      step Contract::Build(constant: Venue::Contract::Create)
    end

    step Nested(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
