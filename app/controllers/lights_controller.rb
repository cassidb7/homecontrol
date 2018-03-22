class LightsController < ApplicationController

  def index
    Light.set_all_lights_state
    @lights = Light.all
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
end
