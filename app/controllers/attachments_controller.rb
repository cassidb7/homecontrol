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
     path = Rails.root.join("public/test_reg.jpg")
     path if File.exists?(path)



     file = File.open(path, 'rb')





     geometry = `identify -format "%w:%h" #{path}`

     puts geometry

     # width  = geometry.split(':')[0].to_i
     # height = geometry.split(':')[1].to_i
     #
     # cmd = "convert "
     # cmd += "-crop #{width}x#{(height * 0.2).round}+0+0 "
     # cmd += "#{file} "
     # system cmd














     # cmd = "tesseract #{path} test1 segdemo inter"

    # convert_to_tiff = "convert -density 300 -depth 8 -strip -background white -alpha off -auto-level -auto-gamma -compress none #{path} #{Rails.root.join("public/output.tiff")}"
    # system convert_to_tiff




   # ocr = "tesseract #{Rails.root.join("public/output.tiff")} stdout"
   # reg_number = ocr[0..4000]
   #
   #   system convert_to_tiff
   #
   #   puts reg_number





     respond_to do |format|

       format.html { redirect_to new_attachment_path, notice: 'I Tried' }
     end
   end

   def attachment_params
     params.require(:attachment).permit(:device_type)
   end

   def show
     @attachment = Attachment.find(params[:id])
   end
end
