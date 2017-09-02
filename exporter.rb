require 'fileutils'
require 'liquid'

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
    @male_images    = Dir.entries("#{source_images}/Male")
    @female_images  = Dir.entries("#{source_images}/Female")

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
        @source_image = @male_images.sample
        @source_image_path    = "#{source_images}/Male/#{@source_image}"
        if File.file?(@source_image_path)
          FileUtils.cp(@source_image_path, @target_image_folder)
          FileUtils.mv(
            "#{filename}_images/#{@source_image}", 
            "#{filename}_images/#{user[:icon]}")
        end
      when "F"
        @source_image = @female_images.sample
        @source_image_path    = "#{source_images}/Female/#{@source_image}"
        if File.file?(@source_image_path)
          FileUtils.cp(@source_image_path, @target_image_folder)
          FileUtils.mv(
            "#{filename}_images/#{@source_image}", 
            "#{filename}_images/#{user[:icon]}")
        end
      end
    end

    # convert the users
    @formatted_list = convert(users: users, format: target_format)

    # save the users to a file
    File.open(filename, 'w') do |f|
      f.write @formatted_list
    end
  end
end
