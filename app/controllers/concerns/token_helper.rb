module TokenHelper
  # Método para invalidar o token e removê-lo do banco
  def invalidate_token(token)
    decoded = JwtService.decode(token)

    if decoded
      # Encontrar e destruir o token na allowlist
      allowlisted_token = AllowlistedToken.find_by(token_jwt: decoded[:token_jwt])

      if allowlisted_token
        allowlisted_token.destroy
      else
        raise ActiveRecord::RecordNotFound, "Token not found in allowlist"
      end
    else
      raise ArgumentError, "Invalid token"
    end
  end

  def current_token
    request.headers["Authorization"]&.split(" ")&.last
  end
end
