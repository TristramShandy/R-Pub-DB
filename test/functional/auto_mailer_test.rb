require 'test_helper'

class AutoMailerTest < ActionMailer::TestCase
  # Reminder email test - call reminder
  test "remind call" do
    rem_1 = reminders(:one)
    actual = AutoMailer.remind(rem_1)

    @expected.from = 'rpubdb@ait.ac.at'
    @expected.to = 'vimes@am_watch.com'
    @expected.subject = 'Reminder from RPubDB'
    @expected.body = read_fixture('remind_call_one')
    # @expected.message_id = actual.message_id

    assert_equal @expected, actual
  end

  # Reminder email test - conference reminder
  test "remind conference" do
    rem_2 = reminders(:two)
    actual = AutoMailer.remind(rem_2)

    @expected.from = 'rpubdb@ait.ac.at'
    @expected.to = 'vimes@am_watch.com'
    @expected.subject = 'Reminder from RPubDB'
    @expected.body = read_fixture('remind_conf_one')

    assert_equal @expected, actual
  end

  # Office email test - conference publication
  test "office conference" do
    publ = publications(:conf_one)
    actual = AutoMailer.published(publ, {"email" => "office@ait.ac.at"})

    @expected.from = 'rpubdb@ait.ac.at'
    @expected.to = 'office@ait.ac.at'
    @expected.subject = 'Publikation'
    @expected.body = read_fixture('office_conf_one')

    assert_equal @expected, actual, "Body expected:\n#{@expected.body}\nBody actual:\n#{actual.body}\n"
  end

  # Office email test - book publication
  test "office book" do
    publ = publications(:book_one)
    actual = AutoMailer.published(publ, {"email" => "office@ait.ac.at"})

    @expected.from = 'rpubdb@ait.ac.at'
    @expected.to = 'office@ait.ac.at'
    @expected.subject = 'Publikation'
    @expected.body = read_fixture('office_book_one')

    assert_equal @expected, actual, "Body expected:\n#{@expected.body}\nBody actual:\n#{actual.body}\n"
  end

  # Office email test - journal publication
  test "office journal" do
    publ = publications(:journal_one)
    actual = AutoMailer.published(publ, {"email" => "office@ait.ac.at"})

    @expected.from = 'rpubdb@ait.ac.at'
    @expected.to = 'office@ait.ac.at'
    @expected.subject = 'Publikation'
    @expected.body = read_fixture('office_jour_one')

    assert_equal @expected, actual, "Body expected:\n#{@expected.body}\nBody actual:\n#{actual.body}\n"
  end

  # Office email test - other publication
  test "office other" do
    publ = publications(:other_one)
    actual = AutoMailer.published(publ, {"email" => "office@ait.ac.at"})

    @expected.from = 'rpubdb@ait.ac.at'
    @expected.to = 'office@ait.ac.at'
    @expected.subject = 'Publikation'
    @expected.body = read_fixture('office_othe_one')

    assert_equal @expected, actual, "Body expected:\n#{@expected.body}\nBody actual:\n#{actual.body}\n"
  end
end
