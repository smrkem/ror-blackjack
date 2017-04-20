require 'test_helper'

class HealthStatusFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test_user_1@example.com", password: "password", password_confirmation: "password",  email_confirmed_at: Time.now)
  end

  test "can input a status on the homepage" do
    get root_path(as: @user)
    assert_response :success
    assert_select "form" do
      assert_select "input[name=?]", "health_status[mindfulness]"
      assert_select "input[name=?]", "health_status[physically_active]"
      assert_select "input[name=?]", "health_status[happiness]"
      assert_select "input[name=?]", "health_status[diet]"
      assert_select "input[name=?]", "health_status[mentally_active]"
      assert_select "input[name=?]", "health_status[socially_active]"
    end
  end

  test "shows errors on missing fields" do
    post health_statuses_path(as: @user), params: { health_status: { mindfulness: "3" } }
    assert_select ".errors li", "Physically active can't be blank"
    assert_select ".errors li", "Happiness can't be blank"
    assert_select ".errors li", "Diet can't be blank"
    assert_select ".errors li", "Mentally active can't be blank"
    assert_select ".errors li", "Socially active can't be blank"
  end

  test "can create a health status for current user" do
    original_count = @user.health_statuses.count
    post health_statuses_path(as: @user), params: health_status_params
    assert_equal original_count + 1, @user.health_statuses.count
  end

  test "redirects to report after create" do
    post health_statuses_path(as: @user), params: health_status_params
    assert_redirected_to health_statuses_path
    follow_redirect!
    assert_response :success
  end

  test "report returns Health Status data" do
    5.downto(1) do |i|
      HealthStatus.create(
        user: @user,
        mindfulness: 3,
        physically_active: 3,
        happiness: 3,
        diet: 3,
        mentally_active: 3,
        socially_active: 3,
        created_at: i.days.ago
      )
    end

    get health_statuses_path as: @user, format: :json
    json_response = JSON.parse(@response.body)

    assert_equal 5, json_response.count
    json_response.each do |health_status|
      assert health_status.key? "mindfulness"
      assert health_status.key? "physically_active"
      assert health_status.key? "happiness"
      assert health_status.key? "diet"
      assert health_status.key? "mentally_active"
      assert health_status.key? "socially_active"
      assert health_status.key? "created_at"
    end
  end

  test "report returns HealthStatuses for selected range" do
    [1.days.ago, 6.days.ago, 29.days.ago, 2.months.ago, 6.months.ago, 2.years.ago].each do |creation_time|
      HealthStatus.create(
        user: @user,
        mindfulness: 3,
        physically_active: 3,
        happiness: 3,
        diet: 3,
        mentally_active: 3,
        socially_active: 3,
        created_at: creation_time
      )
    end

    get health_statuses_path as: @user, format: :json, params: { start_date: "5 days" }
    json_response = JSON.parse(@response.body)
    assert_equal 1, json_response.count

    get health_statuses_path as: @user, format: :json, params: { start_date: "1 month" }
    json_response = JSON.parse(@response.body)
    assert_equal 3, json_response.count

    get health_statuses_path as: @user, format: :json, params: { start_date: "3 months" }
    json_response = JSON.parse(@response.body)
    assert_equal 4, json_response.count

    get health_statuses_path as: @user, format: :json, params: { start_date: "1 year" }
    json_response = JSON.parse(@response.body)
    assert_equal 5, json_response.count
  end

  test "can update a health_status via ajax" do
    @health_status = health_statuses(:one)
    assert_equal 1, @health_status.mindfulness
    @health_status.user = @user
    @health_status.save

    patch health_status_path(@health_status, as: @user), xhr: true, params: health_status_params
    assert_response :success
    assert_equal "text/javascript", @response.content_type

    @user.health_statuses.reload
    assert_equal 3, @user.health_statuses.first.mindfulness
  end

  test "can delete a health_status via ajax" do
    original_count = HealthStatus.all.count
    @health_status = health_statuses(:one)
    @health_status.user = @user
    @health_status.save

    delete health_status_path(@health_status, as: @user), xhr: true
    assert_response :success
    assert_equal "text/javascript", @response.content_type

    assert_equal original_count - 1, HealthStatus.all.count
  end

  private

  def health_status_params
    { health_status: {
      mindfulness: "3",
      physically_active: "3",
      happiness: "3",
      diet: "3",
      mentally_active: "3",
      socially_active: "3"
      } }
  end
end
