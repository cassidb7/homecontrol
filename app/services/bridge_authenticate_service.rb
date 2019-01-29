# app/services/bridge_authentication_service.rb
require 'httparty'

class BridgeAuthenticateService
  include HTTParty

  def initialize(bridge_ip:)
    @bridge_ip = bridge_ip
  end

  def run
    bridge_register(@bridge_ip)
  end

  private

  def bridge_register(bridge_ip)
    return if bridge_ip.blank?

    response = HTTParty.post("http://" + bridge_ip + "/api" ,
       body: { "devicetype":"my_hue_app#homecontrol" }.to_json,
       headers: { 'Content-Type' => 'application/json' })
     @response = JSON.parse response.body

     service_response =
     if @response[0]['error'].present?
       ['error', @response[0]['error']['description']]
     else
       save_bridge_uid(bridge_uid: bridge_uid, setting: @response[0]['success']['username'])
       ['success', @response[0]['success']['username']]
     end

     return service_response
  end


  def save_bridge_uid(bridge_uid:, setting:)
    bridge_uid = ConfigSetting.retrieve('user_identifier')
    bridge_uid.blank? ? ConfigSetting.create!(title: user_identifier, setting: setting) : bridge_uid.update_attributes(setting: setting )
  end
end


 # parsed_response=[{"error"=>{"type"=>101, "address"=>"", "description"=>"link button not pressed"}}]
 # parsed_response=[{"success"=>{"username"=>"mexjqSX1cRL0C-Ac3M9LZnlxpTmWgAyER-E0w0Vm"}}]
