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
    # course info (name, heading, etc.)
    @course = (@client.show_course(params[:id])["course"] || {})

    # enrollments for this course
    enroll_raw = @client.course_enrollments(params[:id])
    enrollments = enroll_raw["enrollments"]|| []
    user_ids = enrollments.map { |u| u["user_id"]}
    
    @students = []
    for u_id in user_ids
      user_detail = @client.show_user(u_id)
      user = {
        name: user_detail["name"],
        email: user_detail["email"]
      }
      user_detail["courses"].each do |course|
        if course["course_id"] == params[:id].to_i && course["is_active_enrollment"] == true
          @students << user 
        end
      end
    end
  end

  private

  def set_client
    @client = Teachable::Client.new
  end
end
