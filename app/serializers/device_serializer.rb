class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :device_uid, :ip_address, :name
end
