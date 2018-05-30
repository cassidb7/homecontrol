class Attachment < ApplicationRecord



  def self.process_image(path)
    file  = File.open(path)
    geometry = `identify -format "%w:%h" #{path}`

    width  = geometry.split(':')[0].to_i
    height = geometry.split(':')[1].to_i

    cmd = "convert "
    cmd += "-crop #{width}x#{height}+0+#{(height - (height/3)).round} "
    cmd += "#{path} "
    cmd += "#{Rails.root.join("public/registration_processing/cropped_output.jpg")}"

    cropped_output = Rails.root.join("public/registration_processing/cropped_output.jpg")
    system cmd

    cmd = "convert "
    cmd += "#{cropped_output} "
    cmd += '-threshold 50% -bordercolor white -border 10 -fill black -draw "color 0,0 floodfill" -alpha off -shave 10x10 '
    cmd += "#{Rails.root.join("public/registration_processing/binary_output.gif")}"

    binary_output = "#{Rails.root.join("public/registration_processing/binary_output.gif")}"
    system cmd

    cmd = "convert "
    cmd += "#{binary_output} "
    cmd += '-define connected-components:verbose=true -connected-components 4 '
    cmd += "#{Rails.root.join("public/registration_processing/layered_output.png")}"
    layered_output = "#{Rails.root.join("public/registration_processing/layered_output.png")}"
    system cmd

    cmd = "convert "
    cmd += "#{layered_output} "
    cmd += '-define connected-components:area-threshold=12119 -connected-components 4 -auto-level -morphology erode octagon:1 '
    cmd += "#{Rails.root.join("public/registration_processing/targeted_output.png")}"
    targeted_output = "#{Rails.root.join("public/registration_processing/targeted_output.png")}"
    system cmd

    cmd = "convert "
    cmd += "#{cropped_output} "
    cmd += "#{targeted_output} "
    cmd += '-alpha off -compose copy_opacity -composite -trim +repage -background white -alpha background -alpha off '
    cmd += "#{Rails.root.join("public/registration_processing/cleansed_output.gif")}"
    cleansed_output = "#{Rails.root.join("public/registration_processing/cleansed_output.gif")}"
    system cmd

    cmd = "convert #{cleansed_output} "
    cmd += "#{Rails.root.join("public/registration_processing/ocr_output.tiff")}"
    ocr_output = "#{Rails.root.join("public/registration_processing/ocr_output.tiff")}"
    system cmd

    cmd = "convert #{ocr_output} -colorspace gray -threshold 30% "
    cmd += "#{Rails.root.join("public/registration_processing/complete_output.tiff")}"
    complete_output = "#{Rails.root.join("public/registration_processing/complete_output.tiff")}"
    system cmd

    cmd = "convert #{complete_output} "
    cmd += "-morphology Dilate Octagon "
    cmd += "#{Rails.root.join("public/registration_processing/test_outpit.tiff")}"
    noise_reduced_output = "#{Rails.root.join("public/registration_processing/test_outpit.tiff")}"
    system cmd

    cmd = "tesseract #{noise_reduced_output} "
    cmd += "#{Rails.root.join("public/registration_processing/complete_output")} "
    system cmd

   Attachment.cleanse_reg_number

  end

  def self.cleanse_reg_number
    reg = File.read("#{Rails.root.join("public/registration_processing/complete_output.txt")}")

    reg.gsub!(/\|/, "1")
    reg.gsub!(/\-/, "")
    reg.gsub!(/\s/, "")

    registrations = Registration.by_length(reg.length)
	
    percentage_equal = []
    registrations.each_with_index do |registration, index|
      loop_counter = 0
      #percentage_equal = []
      registration.number.split("").each do |r|
        percentage_equal << r if r == reg[loop_counter]
        loop_counter += 1
      end


      break if percentage_equal.length == reg.length
    end

    is_equal = percentage_equal.length == reg.length ? true : false

    return is_equal
  end


end
