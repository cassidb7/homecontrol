class Light < ApplicationRecord
  include Conditionable
  require 'uri'
  require 'net/http'

  has_one :state

  delegate :on_state, to: :state

  scope :by_uniqueid, ->(by_uniqueid) { where(uniqueid: by_uniqueid) }
  scope :by_light_identifier, ->(light_identifier) { where(light_identifier: light_identifier).first }


  def self.save_light_details(lights)
    lights.each do |light|
      this_light = Light.where( uniqueid: light[1]['uniqueid'] )

      next unless this_light.blank?

      new_light = Light.create(light_identifier: light[0], uniqueid: light[1]['uniqueid'])
      new_light.save

      State.create!(
        on_state: light[1]['state']['on'],
        brightness_state: light[1]['state']['bri'],
        hue_state: light[1]['state']['hue'],
        saturation_state: light[1]['state']['sat'],
        effect: light[1]['state']['effect'],
        x_state: light[1]['state']['xy'][0],
        y_state: light[1]['state']['effect'][1],
        ct_state: light[1]['state']['ct'],
        alert: light[1]['state']['alert'],
        light_id: new_light.id)
    end
  end


  def self.set_all_lights_state
    lights = Light.send_request

    lights.each do |light|
      this_light = Light.where( uniqueid: light[1]['uniqueid'] )
      next if this_light.blank?
      puts "should update this passed"
      this_light.first.state.update(on_state: light[1]['state']['on'])
    end
  end

  def self.send_request
    bridge_ip = ConfigSetting.retrieve('bridge_ip', "")
    bridge_identity = ConfigSetting.retrieve('user_identifier', "")

    return if bridge_identity.blank? || bridge_ip.blank?

    url = URI("http://" + bridge_ip + "/api/" + bridge_identity + "/lights")

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request) rescue false
    response_read =  JSON.parse(response.read_body) #unless false?(response)

    #Light.remove_lights if false?(response)

    return response_read
  end

  def self.remove_lights
    Light.delete_all
    puts "koala herro"
  end

  def self.send_request_to_light(request_body, light_unique_id, light_status)
    bridge_ip = ConfigSetting.retrieve('bridge_ip')
    bridge_identity = ConfigSetting.retrieve('user_identifier')

    light = Light.by_light_identifier(light_unique_id)


    url = URI("http://" + bridge_ip + "/api/" + bridge_identity + "/lights/" + light.light_identifier.to_s + "/state")

    http = Net::HTTP.new(url.host, url.port)



    request = Net::HTTP::Put.new(url)
    request["content-type"] = 'application/json'
    request.body = request_body


    response = http.request(request)

    light.state.update_attributes( on_state: light_status )
    return response
  end

  def set_dim_setting(dimmer_value)

    bridge_ip = ConfigSetting.retrieve('bridge_ip')
    bridge_identity = ConfigSetting.retrieve('user_identifier')

    url = URI("http://" + bridge_ip + "/api/" + bridge_identity + "/lights/" + self.light_identifier.to_s + "/state")
    puts url
    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Put.new(url)
    request["content-type"] = 'application/json'
    request.body = '{"bri": ' + dimmer_value.to_s + '}'


    puts request.body

    response = http.request(request)



    # self.state.update(brightness_state: dimmer_value)
  end

  def light_boolean
    return self.state.on_state == "t" ?  true : false
  end

end
