require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "alert_class returns proper bootstrap class" do
    assert_equal "alert-success", alert_class("notice")
    assert_equal "alert-warning", alert_class("alert")
    assert_equal "alert-danger", alert_class("error")
  end
end
