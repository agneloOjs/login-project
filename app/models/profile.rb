# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  # Validações
  validates :first_name, presence: true, length: { minimum: 3 }
  validates :last_name, length: { minimum: 2 }, allow_blank: true
  # validates :profile_picture_url, allow_blank: true, format: { with: URI.regexp(%w[http https]), message: "must be a valid URL" }
end
