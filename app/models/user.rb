# frozen_string_literal: true

class User < ApplicationRecord
  # Inclui suporte a autenticação com bcrypt
  has_secure_password

  # Validações
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :code, presence: true, uniqueness: true
  validates :blocked, inclusion: { in: [ true, false ] }
  validates :deleted, inclusion: { in: [ true, false ] }
  validates :active, inclusion: { in: [ true, false ] }

  # Métodos auxiliares
  private

  # Necessário para evitar validação de senha ao atualizar outros atributos
  def password_required?
    new_record? || password.present?
  end
end
