class PowerToggleJob < ApplicationJob
  queue_as :default

  def perform(event, param1)
    ActionCable.server.broadcast 'notification_channel_#{param1}', message: render_event(event)
  end

  private

  def render_event(event)
    ApplicationController.renderer.render(partial: 'lights/light', locals: { light: light })
  end
end
