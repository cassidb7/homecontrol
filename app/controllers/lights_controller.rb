class LightsController < ApplicationController

  def index
    redirect_to register_bridge_lights_path if bridge_registered?
    # Light.set_all_lights_state
    @lights = Light.all
  end

  def register_bridge
  end

  def save_bridge_info
    ip_address = params[:bridge_ip]

    if ConfigSetting.retrieve('bridge_ip').blank?
      ConfigSetting.create(title: 'bridge_ip', setting: ip_address)
      service_response = BridgeAuthenticateService.new(bridge_ip: ip_address).run

      render json: {type: service_response[0], message: service_response[1]}, status: 200
    else
      render json: {message: "Bridge IP address already registered"}, status: 200
    end
  end

  def show
    @light = Light.find(params[:id])
  end

  def find_hue
    Light.send_request
    render :index
  end

  def get_all_lights_info
    lights = Light.send_request

    Light.save_light_details(lights)
    render :index
  end

  def turn_off
    request_body = '{"on":false}'
    Light.send_request_to_light(request_body, params[:uniqueid], false)

    respond_to do |format|
      ActionCable.server.broadcast 'notification_channel', content: "false"
      format.json  { render json: true, status: 200 }
    end
  end

  def turn_on
    request_body = '{"on":true}'
    Light.send_request_to_light(request_body, params[:uniqueid], true)

    respond_to do |format|
      ActionCable.server.broadcast 'notification_channel', content: "true"
      format.json  { render json: true, status: 200 }
    end
  end

  def dim_settings
    dimmer_value = params[:dimmer_value]

    @light = Light.by_light_identifier(params[:light_identifier])

    @light.set_dim_setting(dimmer_value)

    respond_to do |format|
      format.json  { render json: true, status: 200 }
    end
  end

  private

  def bridge_registered?
    bridge_ip = ConfigSetting.retrieve('bridge_ip', "")
    bridge_identity = ConfigSetting.retrieve('user_identifier', "")

    return true if bridge_identity.blank? || bridge_ip.blank?
    false
  end
end
