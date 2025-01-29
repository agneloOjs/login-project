class AllowlistedToken < ApplicationRecord
  belongs_to :user

  # Validações
  validates :token_jwt, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :revoked, inclusion: { in: [ true, false ] }

  # Validação para garantir que o usuário tenha no máximo 3 tokens válidos
  validate :limit_tokens_per_user, on: :create

  # Método para verificar se o token está expirado
  def expired?
    Time.current > expires_at
  end

  # Método para verificar se o token ainda é válido
  def self.valid?(token_jwt)
    allowlisted_token = find_by(token_jwt: token_jwt)
    allowlisted_token && !allowlisted_token.revoked && !allowlisted_token.expired?
  end

  private

  def limit_tokens_per_user
    if user.allowlisted_tokens.where(revoked: false).where("expires_at > ?", Time.current).count >= 3
      errors.add(:base, "User already has the maximum allowed number of active tokens.")
    end
  end
end
