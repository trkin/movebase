class UsersDatatable < BaseDatatable
  def columns
    {
      'users.email': {},
      'users.locale': {},
      'users.confirmed_at': {},
      'users.last_sign_in_at': {},
      'users.provider': {},
      '': {},
    }
  end

  def all_items
    User.all
  end

  def rows(filtered)
    filtered.map do |user|
      link = @view.link_to(user.email, @view.admin_user_path(user))
      actions = @view.link_to @view.t('log_in_as'), @view.sign_in_development_path(user)
      [
        link,
        user.locale,
        user.confirmed_at,
        user.last_sign_in_at,
        user.provider,
        actions,
      ]
    end
  end
end
