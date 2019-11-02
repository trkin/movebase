class ClubUsersDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'users.name': {},
      'users.email': {},
      'club_users.position': {},
      '': {}
    }
  end

  def all_items
    # you can use @view.params
    @view.current_user.club_users.joins(:user)
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |club_user|
      link = @view.button_tag_open_modal @view.edit_club_user_path(club_user), text: club_user.id
      [
        club_user.user.name,
        club_user.user.email,
        club_user.position,
        link,
      ]
    end
  end
end
