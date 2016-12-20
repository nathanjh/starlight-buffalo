class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :title
      t.text :note
      t.string :image_url
      t.references :chapter, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
