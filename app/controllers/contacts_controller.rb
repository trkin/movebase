class ContactsController < ApplicationController
  def show
    @contact = Contact.new(
      email: current_user&.email
    )
  end

  def create
    @contact = Contact.new(
      email: current_user&.email || params[:contact][:email],
      text: params[:contact][:text],
      g_recaptcha_response: params['g-recaptcha-response'],
      current_user: current_user,
      remote_ip: request.remote_ip,
    )
    if @contact.save
      redirect_to contact_path, notice: t('contact_thanks')
    else
      flash.now[:alert] = @contact.errors.full_messages.join(', ')
      render :show
    end
  end

end
