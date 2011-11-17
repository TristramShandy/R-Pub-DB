require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user CRUD" do
    u0 = User.new({:name => 'Worker', :rolemask => 0})

    # saving should fail due to name conflict
    assert(! u0.save)

    u0.name = 'Bee'
    assert(u0.save)
    uid = u0.id

    u1 = User.find_by_id(uid)
    assert(u1)
    assert_equal('Bee', u1.name)
    assert_equal(0, u1.rolemask)

    u0.rolemask = 1
    assert(u0.save)

    u1 = User.find_by_id(uid)
    assert(u1)
    assert_equal('Bee', u1.name)
    assert_equal(1, u1.rolemask)

    u0.delete
    u1 = User.find_by_id(uid)
    assert(! u1)
  end

  test "role queries" do
    u0 = users(:superuser)
    u1 = users(:worker)
    u2 = users(:coordinator)
    u3 = users(:office)
    u4 = users(:manager)

    assert(u0.is_coordinator?)
    assert(u0.is_office?)
    assert(u0.is_manager?)

    assert(! u1.is_coordinator?)
    assert(! u1.is_office?)
    assert(! u1.is_manager?)

    assert(u2.is_coordinator?)
    assert(! u2.is_office?)
    assert(! u2.is_manager?)

    assert(! u3.is_coordinator?)
    assert(u3.is_office?)
    assert(! u3.is_manager?)

    assert(! u4.is_coordinator?)
    assert(! u4.is_office?)
    assert(u4.is_manager?)
  end

  test "function may_see_model" do
    u = []
    u << users(:superuser)
    u << users(:worker)
    u << users(:coordinator)
    u << users(:office)
    u << users(:manager)

    # everyone may see the normal models
    [1, 2, 3, 4].each do |role_id|
      u.each do |a_user|
        assert(a_user.may_see_model?(role_id))
      end
    end

    assert(u[0].may_see_model?(5))
    assert(! u[1].may_see_model?(5))
    assert(u[2].may_see_model?(5))
    assert(u[3].may_see_model?(5))
    assert(u[4].may_see_model?(5))
  end

  test "function all_coordinators" do
    coordinators = User.all_coordinators
    assert_equal(2, coordinators.size)

    ids = coordinators.map {|coo| coo.id}.sort
    assert_equal([1, 3], ids)
  end
end
