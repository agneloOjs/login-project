# frozen_string_literal: true

class CreateAllowlistedTokens < ActiveRecord::Migration[8.0]
  def change
    # Habilita UUIDs para o PostgreSQL
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :allowlisted_tokens, id: :uuid do |t|
      t.string :token_jwt, null: false
      t.string :jti, null: false
      t.datetime :expires_at, null: false
      t.boolean :revoked, default: false

      t.timestamps

      t.references :user, null: false, foreign_key: true, type: :uuid
    end
    add_index :allowlisted_tokens, :token_jwt
  end
end
