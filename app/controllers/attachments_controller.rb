class AttachmentsController < ApplicationController
   def new
     # @attachment = Attachment.new
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

   def read_plate
     path = Rails.root.join("public/registration_processing/jag.jpg")
     path if File.exists?(path)

     whitelisted = Attachment.process_image(path)

     if whitelisted
       Device.open_gate
     else
       logger.info "koala false"
     end



     respond_to do |format|

       format.html { redirect_to new_attachment_path, notice: 'I Tried' }
     end
   end

   def attachment_params
     params.require(:attachment).permit(:image)
   end

   def show
     @attachment = Attachment.find(params[:id])
   end
end
