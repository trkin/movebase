require 'test_helper'

class DisciplineTest < ActiveSupport::TestCase
  test 'valid fixture' do
    assert_valid_fixture disciplines
  end

  test 'consists_of_disciplines' do
    results = disciplines(:quadrathlon).consists_of_disciplines

    assert_includes results, disciplines(:sprint_kayak)
    assert_includes results, disciplines(:cycling)
    assert_includes results, disciplines(:swimming)
    assert_includes results, disciplines(:running)
  end

  test 'used_in_disciplines' do
    results = disciplines(:sprint_kayak).used_in_disciplines

    assert_includes results, disciplines(:kayak_duathlon)
    assert_includes results, disciplines(:quadrathlon)
    assert_not_includes results, disciplines(:sprint_kayak)
  end

  test 'similar_disciplines' do
    results = disciplines(:sprint_kayak).similar_disciplines

    assert_includes results, disciplines(:sprint_kayak_for2)
  end
end
