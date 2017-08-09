require 'csv'
require 'fileutils'

def load_data(fn='first_names.csv', 
              ln='last_names.csv', 
              geo="us_cities_states_counties.csv")
  return {
    people:      CSV.read(fn),
    last_names:  CSV.read(ln).flatten,
    locations:   CSV.read(geo, col_sep: '|'),
    words:       CSV.read('/usr/share/dict/words').flatten
  }
end

def load_original_users(filename='.secret/original_contacts.rb')
  load filename

  return {
    original_1: PhoneContacts::PHONE1,
    original_2: PhoneContacts::PHONE2,
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

def create_icon(gender=FALSE)
  m_path = 'src_pics/Male'
  f_path = 'src_pics/Female'
  males   = Dir.entries(m_path)
  females = Dir.entries(f_path)

  if gender == "M"
    icon = males.sample
    path = "#{m_path}/#{icon}"
    if File.file?(path) 
      FileUtils.cp(path, 'user_pics')
    end
  elsif gender == "F"
    icon = females.sample
    path = "#{f_path}/#{icon}"
    if File.file?(path) 
      FileUtils.cp(path, 'user_pics')
    end
  else
    icon = ""
  end
  
  return icon
end

def create_user(data)
  name = create_name(data[:people], data[:last_names])
  location = create_location(data[:locations], data[:words])
  return {
    first_name: name[:first],
    last_name:  name[:last],
    icon:       create_icon(name[:gender]),
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
