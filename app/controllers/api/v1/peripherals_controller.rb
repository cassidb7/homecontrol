class Api::V1::PeripheralsController < Api::V1::BaseController
  before_action :authenticate_device!


  def handshake
    devices = Device.all

    render json: devices
  end



end
