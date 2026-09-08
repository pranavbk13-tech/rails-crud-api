require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/tasks creates a task" do
    post "/api/v1/tasks",
      params: {
        task: {
          title: "Learn Rails",
          description: "Build a CRUD API",
          completed: false
        }
      },
      as: :json

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal true, json["success"]
    assert_equal "Learn Rails", json.dig("data", "title")
    assert_equal "Build a CRUD API", json.dig("data", "description")
    assert_equal false, json.dig("data", "completed")
  end

  test "PATCH /api/v1/tasks/:id updates a task" do
    patch "/api/v1/tasks/#{tasks(:one).id}",
      params: {
        title: "Learn Ruby on Rails",
        description: "API connected to PostgreSQL.",
        completed: false
      },
      as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal true, json["success"]
    assert_equal "Learn Ruby on Rails", json.dig("data", "title")
    assert_equal "API connected to PostgreSQL.", json.dig("data", "description")
    assert_equal false, json.dig("data", "completed")
  end

  test "PUT /api/v1/tasks/:id updates a task with a task payload" do
    put "/api/v1/tasks/#{tasks(:two).id}",
      params: {
        task: {
          title: "Learn Ruby on Rails",
          description: "API connected to PostgreSQL.",
          completed: false
        }
      },
      as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal true, json["success"]
    assert_equal "Learn Ruby on Rails", json.dig("data", "title")
    assert_equal "API connected to PostgreSQL.", json.dig("data", "description")
    assert_equal false, json.dig("data", "completed")
  end
end
