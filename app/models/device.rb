class Device < ApplicationRecord
  has_secure_token :device_uid

  scope :find_by_ip_address, ->(ip_address) { where(ip_address: ip_address).first }
end
