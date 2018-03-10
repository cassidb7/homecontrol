class ConfigSettingsController < ApplicationController
  before_action :set_config_setting, only: [:show, :edit, :update, :destroy]

  def index
    @config_settings = ConfigSetting.all
  end

  def new
    @config_setting = ConfigSetting.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @config_setting }
    end
  end

  def create
    @config_setting = ConfigSetting.create(config_setting_params)

    respond_to do |format|
      if @config_setting.save
        format.html { redirect_to config_settings_path, notice: "#{@config_setting.title} was successfully created." }
        format.json { render json: @config_setting, status: :created }
      else
        format.html { flash.now[:error] = @config_setting.errors.full_messages
          render 'form' }
        format.json { render json: @config_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @config_setting = ConfigSetting.update(config_setting_params)
  end


  def destroy
    @config_setting.destroy
  end

  private

  def set_config_setting
    @config_setting = ConfigSetting.find(params[:id])
  end

  def config_setting_params
    params.require(:config_setting).permit(:title, :setting)
  end
end
