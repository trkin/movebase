class ClubsDatatable < BaseDatatable
  def columns
    {
      'clubs.id': {},
      'clubs.name': {},
      'clubs.website': {},
      '': { title: @view.t('actions') },
    }
  end

  def rows(filtered)
    filtered.map do |club|
      actions = @view.link_to(@view.t_crud('edit', Club), @view.admin_club_path(club))
      [
        club.id,
        club.name,
        club.website,
        actions,
      ]
    end
  end

  def all_items
    Club.all
  end
end
