class Api::V1::PeripheralsController < Api::V1::BaseController
  before_action :authenticate_device!


  def handshake
    devices = Device.all

    render json: devices
  end

  def handshake_post

    path = params[:image].path

    whitelisted = Attachment.process_image(path)

    if whitelisted
      # Attachment.green_light
      puts "koala true"
    else
      # Attachment.red_light
      puts "koala false"
    end

  end

private

def attachment_params
  params.require(:attachment).permit(:image)
end

end
