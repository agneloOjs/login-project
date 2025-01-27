# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    # Habilita UUIDs para o PostgreSQL
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :profiles, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :profile_picture_url

      t.timestamps

      t.references :user, null: false, foreign_key: true
    end
  end
end
