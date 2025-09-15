# app/controllers/courses_controller.rb
class CoursesController < ApplicationController
  def index
    client = Teachable::Client.new
    raw = client.list_courses(published: true)   # only published
    @courses = raw["courses"] || []
  rescue => e
    flash.now[:alert] = "Could not load courses (#{e.message})."
    @courses = []
  end
  
  def show
  client = Teachable::Client.new

  # course info (name, heading, etc.)
  @course = (client.show_course(params[:id])["course"] || {})

  # enrollments for this course
  enroll_raw = client.course_enrollments(params[:id])
  enrollments = enroll_raw["enrollments"] || []

  # "Active" rule (simple & API-friendly): completed_at == nil
  active_user_ids = enrollments
    .select { |e| e["completed_at"].nil? }
    .map { |e| e["user_id"] }

  # Build a user index (user_id -> {name, email}) using /v1/users (paginated)
  user_index = {}
  page = 1
  loop do
    users_raw = client.list_users(page: page, per_page: 50)
    (users_raw["users"] || []).each do |u|
      user_index[u["id"]] = { name: u["name"], email: u["email"] }
    end
    break if page >= (users_raw.dig("meta", "number_of_pages") || 1)
    page += 1
  end

  # Map active user_ids to student rows
    @students = active_user_ids.map { |uid| user_index[uid] }.compact
  rescue => e
    redirect_to(root_path, alert: "Could not load course ##{params[:id]} (#{e.message}).")
  end
end
