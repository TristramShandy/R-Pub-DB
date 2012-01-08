require 'test_helper'

class JournalTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "issn validation" do
    base_hash = {:name => "Foo", :publisher => "Bar", :url => "http://www.test.com"}

    # correct ISSN
    base_hash[:issn] = "0036-8075"
    j0 = Journal.new(base_hash)
    assert j0.save, "Not saved: #{j0.errors.full_messages.join(', ')}"

    base_hash[:issn] = "0028-0836"
    j0 = Journal.new(base_hash)
    assert j0.save, "Not saved: #{j0.errors.full_messages.join(', ')}"

    base_hash[:issn] = "0000-037X"
    j0 = Journal.new(base_hash)
    assert j0.save, "Not saved: #{j0.errors.full_messages.join(', ')}"

    base_hash[:issn] = " 1931-762x "
    j0 = Journal.new(base_hash)
    assert j0.save, "Not saved: #{j0.errors.full_messages.join(', ')}"

    # wrong ISSN
    base_hash[:issn] = "1000-037X"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    base_hash[:issn] = "0082-0836"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    # badly formatted ISSN
    base_hash[:issn] = "00-28-0836"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    base_hash[:issn] = "00280836"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    base_hash[:issn] = "0028 0836"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    base_hash[:issn] = "0028-086"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    base_hash[:issn] = "0028-08369"
    j0 = Journal.new(base_hash)
    assert ! j0.save

    base_hash[:issn] = "0028-o836"
    j0 = Journal.new(base_hash)
    assert ! j0.save
  end
end
