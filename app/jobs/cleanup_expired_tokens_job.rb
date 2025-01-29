class CleanupExpiredTokensJob < ApplicationJob
  queue_as :default

  def perform
    # Remove tokens que estão expirados ou revogados
    AllowlistedToken.where("expires_at < ?", Time.current).or(AllowlistedToken.where(revoked: true)).destroy_all
  end
end
