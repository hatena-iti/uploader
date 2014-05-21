class Content < ActiveRecord::Base
  validates :s3_bucket, presence: true

  def uploadfile=(file)
    self.filename = file.original_filename
    self.size = filse.size
  end
end
