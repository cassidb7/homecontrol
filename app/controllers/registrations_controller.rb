class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  def index
    @registrations = Registration.all
  end

  def new
    @registration = Registration.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @registration }
    end
  end

  def create
    @registration = Registration.create(registration_params)

    respond_to do |format|
      if @registration.save
        format.html { redirect_to registrations_path, notice: "#{@registration.number} was successfully created." }
        format.json { render json: @registration, status: :created }
      else
        format.html { flash.now[:error] = @registration.errors.full_messages
          render 'form' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @registration = Registration.update(registration_params)
  end


  def destroy
    @registration.destroy
  end

  private

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def registration_params
    params.require(:registration).permit(:number, :owner)
  end
end
