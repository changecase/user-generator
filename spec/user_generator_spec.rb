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

      it "returns the each of these and a list of words in the computer's dictionary" do
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

  describe ".create_phone_number" do
    context "given no arguments" do
      it "returns a valid phone number" do
        @phone_number = UserGenerator.create_phone_number

        expect(@phone_number).to match /1-[1-9]\d{2}-\d{3}-\d{4}/
      end
    end
  end

  describe ".create_email" do
    context "given person and a list of words" do
      it "returns a valid email address" do
        @person = {
          first: "John",
          last:  "Doe"}
        @dictionary = ["example"]
        @email = UserGenerator.create_email @person, @dictionary

        expect(@email).to match /john.doe@example.\w+/
      end
    end
  end

  describe ".create_location" do
    context "given a list of locations and a list of words" do
      before(:context) do
        @location_list = [["Some City","State Short", "This State"]]
        @dictionary = ["example"]
        @location = UserGenerator.create_location @location_list, @dictionary
      end
      it "returns a valid address" do
        expect(@location[:state]).to eq "This State"
        expect(@location[:city]).to eq "Some City"
        expect(@location[:street]).to match /\d{1,4} Example \w+/
      end
    end
  end

  describe ".create_icon" do
    context "given a person" do
      it "names the picture off the person's name" do
        @person = {
          first: "John",
          last:  "Doe",
          gender: "M"}
        @icon = UserGenerator.create_icon(@person)

        expect(@icon).to eq "contact_john_doe.jpg"
      end
    end
  end
end
