class AttachmentsController < ApplicationController
  def new
     @attachment = Attachment.new
   end

   # POST /attachment
   # POST /attachment.json
   def create
     @attachment = Attachment.new(attachment_params)
     image = params[:attachment][:image]

     respond_to do |format|
       if @attachment.save
         if image
           @attachment.image.attach(image)
         end
         format.html { redirect_to @attachment, notice: 'User was successfully created.' }
         format.json { render :show, status: :created, location: @attachment }
       else
         format.html { render :new }
         format.json { render json: @attachment.errors, status: :unprocessable_entity }
       end
     end
   end

   def attachment_params
     params.require(:attachment).permit(:device_type)
   end

   def show
     @attachment = Attachment.find(params[:id])
   end
end
