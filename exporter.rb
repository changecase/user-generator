require 'fileutils'
require 'liquid'
require 'rmagick'

class Exporter
  def self.convert(users:, format:)
    @formatted = Array.new()

    users.sort_by! { |u| u[:first_name] }

    @template = Liquid::Template.parse(
      File.read("data_templates/#{format}.liquid"))

    users.each do |user|
      @formatted.push(
        @template.render(
          'first_name'  => user[:first_name],
          'last_name'   => user[:last_name],
          'icon'        => user[:icon],
          'email'       => user[:email],
          'phone_1'     => user[:phone_1],
          'phone_2'     => user[:phone_2],
          'phone_3'     => user[:phone_3],
          'street'      => user[:street],
          'city'        => user[:city],
          'state'       => user[:state],
          'initials'    => user[:initials]
        )
      )
    end

    return @formatted.join()
  end

  def self.export(filename:, users:, source_images:, target_format:)
    # Create a folder to put the profile images in.
    @target_image_folder = "#{filename}_images"

    unless File.directory?(@target_image_folder)
      Dir.mkdir @target_image_folder
    end

    # Iterate over each user to find the icon name and gender.
    # Use these to grab the right pictures.
    users.each do |user|
      case user[:gender]
      when "M"
        convert_image(identity:      "Male",
                     source_images: source_images, 
                     filename:      filename,
                     user:          user)
      when "F"
        convert_image(identity:      "Female",
                     source_images: source_images,
                     filename:      filename,
                     user:          user)
      end
    end

    # convert the users
    @formatted_list = convert(users: users, format: target_format)

    # save the users to a file
    File.open(filename, 'w') do |f|
      f.write @formatted_list
    end
  end

  class << self
    private def convert_image(identity:, source_images:, 
                              filename:, user:)

      @identity_images = Dir.entries("#{source_images}/#{identity}")
      @source_image = select_image(images: @identity_images)
      @source_image_path = "#{source_images}/#{identity}/#{@source_image}"

      puts @source_image
      if File.file? @source_image_path
        @image = Magick::Image.read(@source_image_path).first
        @image.resize_to_fill(300,300).write(
          "#{filename}_images/#{user[:icon]}")
      end
    end

    private def select_image(images:)
      @ignore_files = [
        ".",
        "..",
        ".DS_Store"
      ]
      @selected_image = images.sample

      if @ignore_files.include? @selected_image
        select_image(images: images)
      else
        return @selected_image
      end
    end
  end
end
