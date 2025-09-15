class CoursesController < ApplicationController
  before_action :set_client

  def index
    raw = @client.list_courses(published: true)   # only published
    @courses = raw["courses"] || []
  rescue => e
    flash.now[:alert] = "Could not load courses (#{e.message})."
    @courses = []
  end
  
  def show
    course_id = params[:id].to_i

    # Fetch course details
    @course = @client.show_course(course_id)["course"] || {}

    # Collect unique user IDs from enrollments
    enrollments = Array(@client.course_enrollments(course_id)["enrollments"])
    user_ids = enrollments.map { |e| e["user_id"] }.uniq

    # Build a hash { user_id => user_hash } for fast lookup
    users_page = @client.list_users
    indexed_users = (users_page["users"] || []).index_by { |u| u["id"] }

    # Pick only users whose ID appears in enrollments
    @students = user_ids.filter_map { |user_id| indexed_users[user_id] }
  end

  private

  def set_client
    @client = Teachable::Client.new
  end
end
