module Devise
  class MyRegistrationsController < RegistrationsController
    def create
      super do |user|
        user.locale = I18n.locale
        if user.valid?
          user.initial_referer = session[:referer]
          user.save!
        end
      end
    end

    def destroy
      Notify.message "destroy_user #{resource.email}", resource: resource
      resource.destroy_my_data!
      super
    end
  end
end
