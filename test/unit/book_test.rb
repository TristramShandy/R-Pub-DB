require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "isbn validation" do
    base_hash = {:title => "Foo", :publisher => "Bar", :editor => "Baz", :year => 2000}

    # correct ISBN 10
    base_hash[:isbn] = "0-321-60166-1"
    b0 = Book.new(base_hash)
    assert b0.save

    base_hash[:isbn] = "0-201-89683-4"
    b0 = Book.new(base_hash)
    assert b0.save

    base_hash[:isbn] = "3-89787-055-X"
    b0 = Book.new(base_hash)
    assert b0.save

    # correct ISBN 13
    base_hash[:isbn] = "978-0-321-60166-7"
    b0 = Book.new(base_hash)
    assert b0.save

    base_hash[:isbn] = "978-0-596-52733-4"
    b0 = Book.new(base_hash)
    assert b0.save

    # wrong ISBN
    base_hash[:isbn] = "0-89787-055-X"
    b0 = Book.new(base_hash)
    assert ! b0.save

    base_hash[:isbn] = "978-0-956-52733-4"
    b0 = Book.new(base_hash)
    assert ! b0.save
    
    # badly formatted ISBN
    base_hash[:isbn] = "3-89787-055-10"
    b0 = Book.new(base_hash)
    assert ! b0.save

    base_hash[:isbn] = "978-0-956-52733"
    b0 = Book.new(base_hash)
    assert ! b0.save

    base_hash[:isbn] = "978-o-596-52733-4"
    b0 = Book.new(base_hash)
    assert ! b0.save
    
  end
end
