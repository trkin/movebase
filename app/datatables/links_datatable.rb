class LinksDatatable < TrkDatatables::ActiveRecord
  def columns
    {
      'links.id': {},
      'links.linkable_type': {},
      'links.linkable_id': {},
      'links.kind': {},
      'links.url': {},
    }
  end

  def all_items
    # you can use @view.params
    Link.all
  end

  def rows(filtered)
    # you can use @view.link_to and other helpers
    filtered.map do |link|
      [
        @view.link_to(link.id, link),
        link.linkable_type,
        link.linkable_id,
        link.kind,
        link.url,
      ]
    end
  end
end
