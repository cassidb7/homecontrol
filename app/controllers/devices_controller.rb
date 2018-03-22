class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  def index
    @devices = Device.all
  end

  def new
    @device = Device.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @device }
    end
  end

  def create
    @device = Device.create(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to devices_path, notice: "#{@device.name} was successfully created." }
        format.json { render json: @device, status: :created }
      else
        format.html { flash.now[:error] = @device.errors.full_messages
          render 'form' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @device = Device.update(device_params)
  end


  def destroy
    @device.destroy
  end

  private

  def set_device
    @device = Device.find(params[:id])
  end

  def device_params
    params.require(:device).permit(:name, :ip_address)
  end
end
