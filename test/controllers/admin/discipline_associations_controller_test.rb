require 'test_helper'

class DisciplineAssociationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:superadmin)
  end

  test 'create similar in another direction' do
    discipline = disciplines(:sprint_kayak)
    associated = disciplines(:hiking)
    assert_difference('DisciplineAssociation.count', 2) do
      post admin_discipline_discipline_associations_path(discipline, params: { discipline_association: { kind: :similar, associated_id: associated.id } })
    end
    assert_includes associated.similar_disciplines, discipline
    assert_includes discipline.similar_disciplines, associated
  end
end
