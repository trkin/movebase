module Devise
  class MyRegistrationsController < RegistrationsController
    def create
      super do |user|
        if user.valid?
          user.initial_referer = session[:referer]
        end
      end
    end

    def destroy
      Notify.message "destroy_user #{resource.email}", my_data: resource.my_data
      resource.destroy_my_data!
      super
    end
  end
end
