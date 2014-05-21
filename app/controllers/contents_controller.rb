class ContentsController < ApplicationController
  def new
    @content = Content.new
  end

  def create
    @content = Content.new(content_params)
    upload_file = params[:content][:upload_filename]

    # get an instance of the S3 interface using the default configuration
    s3 = AWS::S3.new

    # get a bucket
    b = s3.buckets[@content.s3_bucket]

    # upload a file
    o = b.objects[upload_file.original_filename]
    o.write(upload_file.read, :acl => :public_read)

    @content.filename = upload_file.original_filename
    @content.size = upload_file.size
    @content.s3_url = o.public_url.to_s

    if @content.save
      redirect_to contents_path
    else
      render 'new'
    end
  end

  def index
    @contents = Content.all
  end

  def destroy
    @content = Content.find(params[:id])

    # get an instance of the S3 interface using the default configuration
    s3 = AWS::S3.new

    # get a bucket
    b = s3.buckets[@content.s3_bucket]

    # delete a file
    o = b.objects[@content.filename]
    o.delete()

    @content.destroy

    redirect_to contents_path
  end

  private
    def content_params
      params.require(:content).permit(:s3_bucket)
    end
end
