require 'test_helper'

class HappeningsForDisciplinesDatatableTest < ActiveSupport::TestCase
  def sample_view_params(params = {})
    OpenStruct.new(
      params: params
    )
  end

  test 'find kayaking happenings: regatta, personal' do
    results = HappeningsForDisciplinesDatatable.new(sample_view_params(discipline_ids: [disciplines(:sprint_kayak).id])).all_items

    assert_includes results, happenings(:kayak_regatta)
    assert_not_includes results, happenings(:personal_long_kayaking)
  end

  test 'find similar_disciplines' do
    results = HappeningsForDisciplinesDatatable.new(sample_view_params(discipline_ids: [disciplines(:sprint_kayak).id, disciplines(:hiking).id])).similar_disciplines

    assert_includes results, disciplines(:sprint_kayak_for2)
    assert_not_includes results, disciplines(:sprint_kayak)
    assert_not_includes results, disciplines(:sprint_kayak_or_recreational_kayak)
  end
end
