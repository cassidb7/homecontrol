class Device < ApplicationRecord
  require 'rpi_gpio'

  has_secure_token :device_uid

  scope :find_by_ip_address, ->(ip_address) { where(ip_address: ip_address).first }

  def self.open_gate
    pin_out = 17  # LED

    RPi::GPIO.set_numbering(:bcm)
    RPi::GPIO.set_warnings(0)
    RPi::GPIO.setup(pin_out, as: :output)

    begin
      now = Time.now
      counter = 1
      loop do
        if Time.now < now + counter
          next
        else
          blink(pin_out)
          sleep(0.2)
        end
        counter += 1
        break if counter > 10
      end

    rescue Interrupt
      puts 'Done'
    ensure
      RPi::GPIO.clean_up
    end
  end

  def blink(pin)
    puts("Button pressed")
    RPi::GPIO.set_high(pin)
    sleep(0.2)
    RPi::GPIO.set_low(pin)
  end
end
