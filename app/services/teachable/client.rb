# frozen_string_literal: true

module Teachable
  class Client
    BASE = ENV.fetch('TEACHABLE_API_BASE', 'https://developers.teachable.com')
    LOGGER = defined?(Rails) && Rails.logger ? Rails.logger : Logger.new($stdout)

    def initialize(api_key: ENV.fetch('TEACHABLE_API_KEY'))
      @api_key = api_key
      @conn = Faraday.new(url: BASE) do |f|
        f.response :json, content_type: /\bjson$/
        f.response :logger, LOGGER, bodies: false
        f.adapter Faraday.default_adapter
      end
    end

    def list_courses(page: 1, per_page: 20, published: nil)
      params = { page: page, per_page: per_page }
      params[:published] = published unless published.nil?
      get_json('/v1/courses', params)
    end

    def show_course(id)
      get_json("/v1/courses/#{id}")
    end

    def course_enrollments(course_id, page: 1, per_page: 50)
      get_json("/v1/courses/#{course_id}/enrollments", { page: page, per_page: per_page })
    end

    def list_users(page: 1, per_page: 50)
      get_json('/v1/users', { page: page, per_page: per_page })
    end

    def show_user(id)
      get_json("/v1/users/#{id}")
    end

    def show_user_cached(id)
      Rails.cache.fetch(['teachable_user', id], expires_in: 10.minutes) do
        show_user(id)
      end
    end

    private

    def get_json(path, params = {})
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      LOGGER.info("[Teachable] → GET #{path} params=#{params.inspect}")

      res = @conn.get(path, params) do |req|
        req.headers['apiKey'] = @api_key
        req.headers['Accept'] = 'application/json'
      end

      ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round
      LOGGER.info("[Teachable] ← #{res.status} #{path} (#{ms}ms)")

      raise(StandardError, "API error #{res.status}: #{safe_message(res)}") unless res.success?

      res.body
    end

    def safe_message(res)
      body = res.body
      if body.is_a?(Hash) && body['message']
        body['message']
      else
        body.to_s[0, 200]
      end
    end
  end
end
