class JwtService
  SECRET_KEY = Rails.application.credentials.jwt_secret

  # Gera o token JWT com o jti (JWT ID)
  def self.encode(payload, expires_at = 24.hours.from_now)
    payload[:expires_at] = expires_at.to_i
    payload[:jti] = SecureRandom.uuid  # Adiciona o jti ao payload
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodifica o token JWT
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
