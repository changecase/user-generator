require './user_generator.rb'

describe UserGenerator do

  describe ".load_data" do

    context "given no arguments" do
      it "errors if the files/data are not provided" do
        expect{UserGenerator.load_data}.to raise_error(ArgumentError)
      end
    end

    context "given first names, last names, and locations" do
      before(:context) do
        @ppl = [["John", "M"],
                ["Jane", "F"]]
        @last = ["Doe","Dough"]
        @loc = [["Portland","Oregon"],
                ["Tacoma","Washington"]]
        @original = [{
          first_name: "Tom",
          last_name:  "Testerson",
          icon:       "contact_tom_testerson.jpg",
          phone_1:    "1-555-123-4567",
          phone_2:    "",
          phone_3:    "",
          email:      "tom@example.com",
          street:     "1234 Street Ave.",
          state:      "Sample",
          city:       "Exampleton",
          initials:   "TT"
        }]
      end

      it "returns each of these and a list of words in the computer's dictionary" do
        @users = UserGenerator.load_data(
          people: @ppl, 
          last_names: @last, 
          locations: @loc)
        expect(@users[:people]).not_to      eq nil
        expect(@users[:last_names]).not_to  eq nil
        expect(@users[:locations]).not_to   eq nil
        expect(@users[:words]).not_to       eq nil
        expect(@users[:base]).to            eq nil
      end

      it "adds the specific users if they're included" do
        @users = UserGenerator.load_data(
          people: @ppl, 
          last_names: @last, 
          locations: @loc,
          originals: @original)
        expect(@users[:base][0][:first_name]).to eq "Tom"
      end
    end
  end

  describe ".create_user" do
    context "given data loaded into an object" do
      before(:context) do
        @data = {
          people:     [["John","M"],
                       ["Jane","F"]],
          last_names: ["Doe", 
                       "Dough"],
          locations:  [["Portland","OR","Oregon"],
                       ["Tacoma",  "WA","Washington"]],
          words:      ["example"]}
        @user = UserGenerator.create_user(@data)
      end

      it "creates a new user" do
        expect(@user).to have_key :first_name
        expect(@user).to have_key :last_name
        expect(@user).to have_key :initials
        expect(@user).to have_key :gender
        expect(@user).to have_key :phone_1
        expect(@user).to have_key :phone_2
        expect(@user).to have_key :phone_3
        expect(@user).to have_key :icon
        expect(@user).to have_key :email
        expect(@user).to have_key :street
        expect(@user).to have_key :city
        expect(@user).to have_key :state
      end

      it "creates first name, last name, and gender for the user" do
        expect(@user[:first_name]).to match /John|Jane/
        expect(@user[:last_name]).to  match /Doe|Dough/
        expect(@user[:initials]).to   eq "JD"
      end

      it "determines the gender of the user" do
        expect(@user[:gender]).to     match(/M|F/)
      end

      it "creates phone numbers for the user" do
        expect(@user[:phone_1]).to    match(/1-[1-9]\d{2}-\d{3}-\d{4}/)
        expect(@user[:phone_2]).to    match(/1-[1-9]\d{2}-\d{3}-\d{4}/)
        expect(@user[:phone_3]).to    match(/1-[1-9]\d{2}-\d{3}-\d{4}/)
      end

      it "creates an email address for the user" do
        expect(@user[:email]).to      match(
          /(john|jane)\.(doe|dough)@example\.\w+/)
      end

      it "creates an address for the user" do
        expect(@user[:street]).to     match /\d{1,4} Example \w+/
        expect(@user[:city]).to       match /Portland|Tacoma/
        expect(@user[:state]).to      match /Oregon|Washington/
      end

      it "creates a profile picture for the user" do
        expect(@user[:icon]).to       match(
        /contact_(john|jane)_(doe|dough)\.jpg/)
      end
    end
  end

  describe ".create_users" do
    context "given data loaded into an object" do
      before(:context) do
        @data = UserGenerator.load_data(
          people: [["John", "M"],
                   ["Jane", "F"]], 
          last_names: ["Doe","Dough"], 
          locations: [["Portland","Oregon"],
                      ["Tacoma","Washington"]],
          originals: [{
            first_name: "Tom",
            last_name:  "Testerson",
            icon:       "contact_tom_testerson.jpg",
            phone_1:    "1-555-123-4567",
            phone_2:    "",
            phone_3:    "",
            email:      "tom@example.com",
            street:     "1234 Street Ave.",
            state:      "Sample",
            city:       "Exampleton",
            initials:   "TT"
          }]
        )
        @users = UserGenerator.create_users(data: @data, amount: 3)
      end

      it "creates the number of users specified" do
        expect(@users.length).to eq 3
      end

      it "contains any base users" do
        @user = @users.select do |user|
          user[:icon] == "contact_tom_testerson.jpg"
        end

        expect(@user).not_to be nil
      end
    end
  end
end
