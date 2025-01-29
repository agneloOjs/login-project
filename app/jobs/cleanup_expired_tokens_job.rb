class CleanupExpiredTokensJob < ApplicationJob
  queue_as :default

  def perform
    AllowlistedToken.where("expires_at < ?", Time.current).destroy_all
  end
end
