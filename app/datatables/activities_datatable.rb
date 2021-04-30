class ActivitiesDatatable < BaseDatatable
  def columns
    {
      'activities.id': {hide: true},
      'activities.name': {},
    }
  end

  def all_items
    Activity.all
  end

  def rows(filtered)
    filtered.map do |activity|
      [
        activity.id,
        @view.link_to(activity.name, @view.activity_path(activity))
      ]
    end
  end
end
