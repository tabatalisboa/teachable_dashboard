# frozen_string_literal: true

module Teachable
  # A lightweight value object representing a course row from GET /v1/courses
  class Course
    # Define read-only getters for each attribute
    attr_reader :id, :name, :heading, :description, :is_published, :image_url

    # The initializer receives keyword arguments for clarity and safety
    def initialize(id:, name:, heading:, description:, is_published:, image_url:)
      @id            = id
      @name          = name
      @heading       = heading
      @description   = description
      @is_published  = is_published
      @image_url     = image_url
    end

    # Build a Course from the API hash (keys as in your JSON)
    def self.from_api(h)
      new(
        id: h.fetch('id'), # fetch raises if missing: required field
        name: h['name'],
        heading: h['heading'],
        description: h['description'],
        is_published: h['is_published'],
        image_url: h['image_url']
      )
    end
  end
end
