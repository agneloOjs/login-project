# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile

  accepts_nested_attributes_for :profile, allow_destroy: true

  has_secure_password
  before_validation :generate_unique_code, on: :create

  # Validações
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :code, presence: true, uniqueness: true
  validates :blocked, inclusion: { in: [ true, false ] }
  validates :deleted, inclusion: { in: [ true, false ] }
  validates :active, inclusion: { in: [ true, false ] }

  # Métodos Privados
  private

  # Necessário para evitar validação de senha ao atualizar outros atributos
  def password_required?
    new_record? || password.present?
  end

  def generate_unique_code
    loop do
      self.code = rand(100000..999999)
       Rails.logger.info "Generated code: #{self.code}"
       break unless User.exists?(code: code)
     end
   end
end
