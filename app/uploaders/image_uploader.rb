class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
