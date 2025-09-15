# frozen_string_literal: true

module Teachable
  class Course
    attr_reader :id, :name, :heading, :description, :is_published, :image_url

    def initialize(id:, name:, heading:, description:, is_published:, image_url:)
      @id            = id
      @name          = name
      @heading       = heading
      @description   = description
      @is_published  = is_published
      @image_url     = image_url
    end

    def self.from_api(h)
      new(
        id: h.fetch('id'),
        heading: h['heading'],
        description: h['description'],
        is_published: h['is_published'],
        image_url: h['image_url']
      )
    end
  end
end
