# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_client

  def index
    raw = @client.list_courses(published: true) # only published
    @courses = raw['courses'] || []
  rescue StandardError => e
    flash.now[:alert] = "Could not load courses (#{e.message})."
    @courses = []
  end

  def show
    course_id = params[:id].to_i
    @course = @client.show_course(course_id)['course'] || {}

    # Collect unique user IDs from this course's enrollments
    user_ids = Array(@client.course_enrollments(course_id)['enrollments'])
               .map { |e| e['user_id'] }
               .uniq

    # Build { user_id => user_hash } from *all pages* of /v1/users
    indexed_users = fetch_all_users_indexed

    # Keep only users whose IDs are in this course's enrollments
    @students = user_ids.filter_map { |uid| indexed_users[uid] }
  end

  private

  def set_client
    @client = Teachable::Client.new
  end

  def fetch_all_users_indexed(per_page: 50)
    Rails.cache.fetch('teachable:users:index', expires_in: 10.minutes) do
      page  = 1
      index = {}
      loop do
        resp  = @client.list_users(page: page, per_page: per_page)
        users = Array(resp['users'])
        index.merge!(users.index_by { |u| u['id'] })
        break if page >= (resp.dig('meta', 'number_of_pages') || 1)

        page += 1
      end
      index
    end
  end
end
