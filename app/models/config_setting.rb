class ConfigSetting < ApplicationRecord

  scope :by_title, ->(title) { where(title: title) }

  def self.retrieve(s, default='', cached = true)
    if cached
      Rails.cache.fetch("ConfigSetting_#{s}") { ConfigSetting.by_title(s).first&.setting }
    else
       ConfigSetting.by_title(s).first.setting
    end
  end

end
