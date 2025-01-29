class JwtService
  SECRET_KEY = Rails.application.secrets.secret_key_base

  # Gera um token JWT
  def self.encode(payload, expires_at = 24.hours.from_now)
    payload[:expires_at] = expires_at.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodifica um token JWT
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
