require 'csv'

def load_data(fn='first_names.csv', 
              ln='last_names.csv', 
              geo="us_cities_states_counties.csv")
  return {
    first_names: CSV.read(fn).flatten,
    last_names:  CSV.read(ln).flatten,
    locations:   CSV.read(geo, col_sep: '|'),
    words:       CSV.read('/usr/share/dict/words').flatten
  }
end

def create_name(first_names, last_names)
  f = first_names.sample
  l = last_names.sample
  i = "#{f[0].upcase}#{l[0].upcase}"
  return {
    first: f,
    last:  l,
    initial: i
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

def create_user(data)
  name = create_name(data[:first_names], data[:last_names])
  location = create_location(data[:locations], data[:words])
  return {
    first_name: name[:first],
    last_name:  name[:last],
    icon:       "contact_#{name[:first].downcase}_#{name[:last].downcase}.png",
    phone_1:    create_phone_number,
    phone_2:    create_phone_number,
    phone_3:    create_phone_number,
    email:      create_email(name, data[:words]),
    street:     location[:street],
    state:      location[:state],
    city:       location[:city]
  }
end

def create_users(number)
  data = load_data
  users = Array.new()

  number.times do
    user = create_user(data)

    users.push(
      <<-ITEM
      ListElement {
        first_name: #{user[:first_name]}
        last_name: #{user[:last_name]}
        icon: #{user[:icon]}
        email: #{user[:email]}
        phone1: #{user[:phone_1]}
        phone2: #{user[:phone_2]}
        phone3: #{user[:phone_3]}
        street: #{user[:street]}
        city: #{user[:city]}
        state: #{user[:state]}
      }
      ITEM
    )
  end

  return users.join()
end

def export_users(filename, number_of_users)
  File.open(filename, 'a') do |f|
    f.write create_users(number_of_users)
  end
end
