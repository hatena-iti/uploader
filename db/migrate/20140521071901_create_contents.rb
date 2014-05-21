class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string  :filename
      t.integer :size
      t.string  :s3_bucket
      t.string  :s3_url

      t.timestamps
    end
  end
end
