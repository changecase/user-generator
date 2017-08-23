Generate Contacts in Custom Format
==================================

Load the user generator:

```ruby
# my_contacts.rb

require './user_generator'
```

If you have a list of original contacts or contacts you'd like
to make sure get included, load that file as well.

```ruby
# my_contacts.rb

require './user_generator'
require '.secret/original_contacts'
```

If you just want to load the data and operate on it in a
non-default way, use the `load_data` method.

```ruby
# my_contacts.rb

...

csv_data = UserGenerator.load_data(
  people:     'first_names_and_gender.csv',
  last_names: 'last_names.csv',
  locations:  'us_cities_states_counties.csv',
  originals:  PhoneContacts::PHONE1
)
```

```csv
# first_names_and_gender.csv

Aaban,M
Aabha,F
Aabid,M
Aabir,M
...
Zyvon,M
Zyyanna,F
Zyyon,M
Zzyzx,M
```

```csv
# last_names.csv

SMITH
JOHNSON
WILLIAMS
...
TRAVIS
TANG
ARCHER
```

```csv
# us_cities_states_counties.csv

City|State short|State full|County|City alias
Holtsville|NY|New York|SUFFOLK|Internal Revenue Service
Holtsville|NY|New York|SUFFOLK|Holtsville
Adjuntas|PR|Puerto Rico|ADJUNTAS|URB San Joaquin
Adjuntas|PR|Puerto Rico|ADJUNTAS|Jard De Adjuntas
...
Klawock|AK|Alaska|PRINCE OF WALES HYDER|Klawock
Metlakatla|AK|Alaska|PRINCE OF WALES HYDER|Metlakatla
Point Baker|AK|Alaska|PRINCE OF WALES HYDER|Point Baker
Ward Cove|AK|Alaska|KETCHIKAN GATEWAY|Ward Cove
Wrangell|AK|Alaska|WRANGELL|Wrangell
```


```ruby
# .secret/original_contacts.rb

class PhoneContacts
  PHONE1 = [
    {
      first_name: "Tom",
      last_name:  "Testerson",
      icon:       "contact_tom_testerson.jpg",
      phone_1:    "1-555-123-4567",
      phone_2:    "1-123-456-7890",
      phone_3:    "1-234-567-8901",
      email:      "tom@example.com",
      street:     "1234 Street Ave.",
      state:      "Sample",
      city:       "Exampleton",
      initials:   "TT"
    },
    {
      first_name: "John",
      last_name:  "Doe",
      icon:       "contact_john_doe.jpg",
      phone_1:    "1-345-678-9012",
      phone_2:    "1-456-789-0123",
      phone_3:    "1-567-890-1234",
      email:      "john.doe@example.com",
      street:     "567 Lane St.",
      state:      "Test",
      city:       "Nevada",
      initials:   "JD"
    }
  ]
end
```
