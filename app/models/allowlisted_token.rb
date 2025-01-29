class AllowlistedToken < ApplicationRecord
  belongs_to :user

  validates :token_jwt, presence: true, uniqueness: true
  validates :expires_at, presence: true

  # Método para verificar se o token ainda é válido
  def self.valid?(token)
    exists?(token: token)
  end
end
