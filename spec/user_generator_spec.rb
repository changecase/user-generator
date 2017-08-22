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
end
