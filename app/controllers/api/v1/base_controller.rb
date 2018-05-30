class Api::V1::BaseController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def api_safe_device_uid
    request.headers['x-api-device-uid'].presence
  end

  def api_safe_ip_address
    request.headers['x-api-ip-address'].presence
  end

  def authenticate_device!
    device_ip_address      = api_safe_ip_address
    device_uid = api_safe_device_uid

    @device = device_ip_address && Device.find_by_ip_address(device_ip_address)
    # in the database with the token given in the params, mitigating timing attacks.
    if ActiveSupport::SecurityUtils.secure_compare(@device.device_uid, device_uid)
      @current_device = @device
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: { error: 'Bad credentials' }, status: 401
  end

  def unauthorized!
    render json: { error: 'not authorized' }, status: 403
  end

end
