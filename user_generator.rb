require 'csv'
require 'fileutils'

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
      words:       CSV.read('/usr/share/dict/words').flatten,
      base:        originals
    }
  end

  def create_name(people, last_names)
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

  def create_phone_number
    return "1-#{rand(100..999)}-#{'%003d' % rand(10**3)}-#{'%004d' % rand(10**4)}"
  end

  def create_email(name, word_list)
    first = name[:first].downcase
    last = name[:last].downcase
    server = word_list.sample
    domain = ["com","net","gov","org"].sample

    return "#{first}.#{last}@#{server}.#{domain}"
  end

  def create_location(locations, word_list)
    location = locations.sample
    road_type = [
      "Rd", "Ln", "St", "Ave", "Ct", "Cir", "Bnd", "Blvd", 
      "Dr", "Garden", "Hwy", "Jct", "Lk", "Loop", "Park", 
      "Pkwy", "Pl", "Plz", "Rue", "Terrace", "Way"]
    return {
      state: location[2],
      city:  location[0],
      street: "#{rand(0..9999)} #{word_list.sample.capitalize} #{road_type.sample}"
    }
  end

  def create_icon(name)
    gender = FALSE || name[:gender]
    m_path = 'src_pics/Male'
    f_path = 'src_pics/Female'
    males   = Dir.entries(m_path)
    females = Dir.entries(f_path)
    dest_icon = "contact_#{name[:first].downcase}_#{name[:last].downcase}.jpg"

    if gender == "M"
      src_icon = males.sample
      src_path = "#{m_path}/#{src_icon}"
      if File.file?(src_path) 
        FileUtils.cp(src_path, 'user_pics')
        FileUtils.mv("user_pics/#{src_icon}", "user_pics/#{dest_icon}")
      end
    elsif gender == "F"
      src_icon = females.sample
      src_path = "#{f_path}/#{src_icon}"
      if File.file?(src_path) 
        FileUtils.cp(src_path, 'user_pics')
        FileUtils.mv("user_pics/#{src_icon}", "user_pics/#{dest_icon}")
      end
    else
      dest_icon = ""
    end
    
    return dest_icon
  end

  def create_user(data)
    name = create_name(data[:people], data[:last_names])
    location = create_location(data[:locations], data[:words])
    return {
      first_name: name[:first],
      last_name:  name[:last],
      icon:       create_icon(name),
      phone_1:    create_phone_number,
      phone_2:    create_phone_number,
      phone_3:    create_phone_number,
      email:      create_email(name, data[:words]),
      street:     location[:street],
      state:      location[:state],
      city:       location[:city],
      initials:   name[:initial]
    }
  end

  def create_users(number, phone)
    data = load_data
    users = Array.new()
    originals = load_original_users[phone]

    originals.each do |user|
      users.push(user)
    end

    number.times do
      user = create_user(data)

      users.push(user)
    end

    return users
  end

  def convert_to_qml(contacts)
    users = Array.new()

    contacts.sort_by! { |c| c[:first_name] }

    contacts.each do |user|
      users.push(
        <<-ITEM
        ListElement {
          first_name: "#{user[:first_name]}"
          last_name: "#{user[:last_name]}"
          icon: "#{user[:icon]}"
          email: "#{user[:email]}"
          phone1: "#{user[:phone_1]}"
          phone2: "#{user[:phone_2]}"
          phone3: "#{user[:phone_3]}"
          street: "#{user[:street]}"
          city: "#{user[:city]}"
          state: "#{user[:state]}"
          initials: "#{user[:initials]}"
        }
        ITEM
      )
    end

    return users.join()
  end

  def export_users(filename, number_of_users, phone)
    users = create_users(number_of_users, phone)
    
    File.open(filename, 'a') do |f|
      f.write convert_to_qml(users)
    end
  end
end
