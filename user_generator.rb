require 'csv'
#require 'fileutils'

class UserGenerator
  def self.load_data(people:, last_names:, locations:, originals: nil)
    @fn   = people 
    @ln   = last_names 
    @geo  = locations

    case @fn
    when /\.csv$/
      people_data = CSV.read(@fn)
    else
      people_data = @fn
    end

    case @ln
    when /\.csv$/
      last_name_data = CSV.read(@ln).flatten
    else
      last_name_data = @ln
    end

    case @geo
    when /\.csv$/
      location_data = CSV.read(@geo, col_sep: '|')
    else
      location_data = @geo
    end

    return {
      people:      people_data,
      last_names:  last_name_data,
      locations:   location_data,
      #words:       CSV.read('/usr/share/dict/words').flatten,
      words:       CSV.table('data/china/New_HSK_2010.csv'),
      base:        originals
    }
  end

  def self.create_users(data:, amount:)
    users = Array.new()
    originals = data[:base]

    unless originals.nil?
      amount -= originals.length

      originals.each do |user|
        user[:original] = true
        users.push(user)
      end
    end

    amount.times do
      @user = create_user(data)
      users.push(@user)
    end

    return users
  end

  # Private methods. These only need to be used to create users
  class << self
    def create_user(data)
      name = create_name(data[:people], data[:last_names])
      email = create_email(name, data[:words][:pinyin])
      location = create_location(data[:locations], data[:words][:word])
      work_phone_type = rand(0..1) > 0.6 ? 'cell' : 'land'
      return {
        first_name: name[:first],
        last_name:  name[:last],
        icon:       create_icon(email),
        phone_1:    create_phone_number(type: 'cell'),
        phone_2:    create_phone_number(type: 'land'),
        phone_3:    create_phone_number(type: work_phone_type),
        email:      email,
        street:     location[:street],
        state:      location[:state],
        city:       location[:city],
        initials:   name[:initial],
        gender:     name[:gender]
      }
    end

    private def create_name(people, last_names)
      p = people.sample
      f = p[0]
      l = last_names.sample.gsub(/\w+/) { |n| n.capitalize }
      i = "#{f[0].upcase}#{l[0].upcase}"

      return {
        first: f,
        last:  l,
        initial: i,
        gender: p[1]
      }
    end

    private def create_phone_number(type:)
      case type
      when 'land'
        prefixes = []
        prefixes.push(10,20,21,22,23,24,25,27,28,29,
                      310,311,312,313,314,415,316,317,318,319,
                      335,349,350,351,352,353,354,355,356,357,358,
                      359,371,372,373,374,375,376,377,379,370,391,
                      392,393,394,295,296,397,398)
        prefix = prefixes.sample

        return "(0#{prefix}) #{'%004d' % rand(10**4)} #{'%004d' % rand(10**4)}"
      when 'cell'
        prefixes = (130..139).to_a
        prefixes.push(145,147,151,152,153,155,156,157,158,
                      159,166,170,171,173,174,176,177,178,
                      180,181,182,183,184,185,186,187,188,
                      189,198,199)

        return "#{prefixes.sample} #{'%004d' % rand(10**4)} #{'%004d' % rand(10**4)}"
      end
    end

    private def create_email(name, word_list)
      first = word_list.sample.gsub(/\d*\s*/,"")
      last = word_list.sample.gsub(/\d*\s*/,"")
      server = word_list.sample.gsub(/\d*\s*/,"")
      domain = ["ac","com","edu","gov","mil","net","org"].sample

      return "#{first}.#{last}@#{server}.#{domain}.cn"
    end

    private def create_location(locations, word_list)
      location = locations.sample
      street_address = locations.sample[3]
      house_number = rand(0..999)
      room_number = rand(0..9999)

      if rand(0..1) > 0.7 
        street_address += "|#{house_number}"
        if rand(0..1) > 0.7
          street_address += "|#{room_number}"
        end
      end

      return {
        state: location[0],
        city:  "#{location[1]}|#{location[2]}",
        street: street_address
      }
    end

    private def create_icon(email)
      identifier = email.gsub(/(.*)\.(.*)@.*$/,'\1_\2')
      return "contact_#{identifier}.jpg"
    end
  end
#
#  def export_users(filename, number_of_users, phone)
#    users = create_users(number_of_users, phone)
#    
#    File.open(filename, 'a') do |f|
#      f.write convert_to_qml(users)
#    end
#  end
end
