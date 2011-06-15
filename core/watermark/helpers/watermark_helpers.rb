class Main
  module WatermarkHelpers
    def admin_watermark
      return  if current_user.nil?
      partial 'watermark/watermark'
    end
  end

  helpers WatermarkHelpers
end
