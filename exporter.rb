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
end
