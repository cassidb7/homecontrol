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

     file = File.open(path, 'rb')

     geometry = `identify -format "%w:%h" #{path}`

     width  = geometry.split(':')[0].to_i
     height = geometry.split(':')[1].to_i
     

     cmd = "convert "
     cmd += "-crop #{width}x#{height}+0+#{(height - (height/3)).round} "
     cmd += "#{path} "
     cmd += "#{Rails.root.join("public/registration_processing/cropped_output.jpg")}"
     
     cropped_output = Rails.root.join("public/registration_processing/cropped_output.jpg")
     system cmd


     # convert the image to black and white
    cmd = "convert "
    cmd += "#{cropped_output} "
    cmd += '-threshold 50% -bordercolor white -border 10 -fill black -draw "color 0,0 floodfill" -alpha off -shave 10x10 '
    cmd += "#{Rails.root.join("public/registration_processing/binary_output.gif")}"
    
    binary_output = "#{Rails.root.join("public/registration_processing/binary_output.gif")}"
    system cmd
    
    
    # split image into layers to find most white background area
    cmd = "convert "
    cmd += "#{binary_output} "
    cmd += '-define connected-components:verbose=true -connected-components 4 '
    cmd += "#{Rails.root.join("public/registration_processing/layered_output.png")}"
    
    layered_output = "#{Rails.root.join("public/registration_processing/layered_output.png")}"
    puts cmd
    system cmd





    # target the layer with the largest white background
    cmd = "convert "
    cmd += "#{layered_output} "
    cmd += '-define connected-components:area-threshold=12119 -connected-components 4 -auto-level -morphology erode octagon:1 '
    cmd += "#{Rails.root.join("public/registration_processing/targeted_output.png")}"
    
    targeted_output = "#{Rails.root.join("public/registration_processing/targeted_output.png")}"
    puts cmd
    system cmd



    # target the layer with the largest white background
    cmd = "convert "
    cmd += "#{cropped_output} "
    cmd += "#{targeted_output} "
    cmd += '-alpha off -compose copy_opacity -composite -trim +repage -background white -alpha background -alpha off '
    cmd += "#{Rails.root.join("public/registration_processing/cleansed_output.gif")}"    
    cleansed_output = "#{Rails.root.join("public/registration_processing/cleansed_output.gif")}"
    
    puts cmd
    system cmd
    
    # convert to tiff for ocr
    cmd = "convert #{cleansed_output} "
    cmd += "#{Rails.root.join("public/registration_processing/ocr_output.tiff")}"
    ocr_output = "#{Rails.root.join("public/registration_processing/ocr_output.tiff")}"

    puts cmd
    system cmd



    cmd = "convert #{ocr_output} -colorspace gray -threshold 30% " 
    cmd += "#{Rails.root.join("public/registration_processing/complete_output.tiff")}"
    complete_output = "#{Rails.root.join("public/registration_processing/complete_output.tiff")}"
    system cmd


    cmd = "tesseract #{complete_output} "
    cmd += "#{Rails.root.join("public/registration_processing/complete_output")} "
    system cmd
    
    cmd = "tesseract #{ocr_output} "
    cmd += "#{Rails.root.join("public/registration_processing/ocr_output")} "
    system cmd







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
