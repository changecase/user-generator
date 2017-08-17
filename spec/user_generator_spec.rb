require './user_generator.rb'

describe UserGenerator do

  describe ".load_data" do

    context "given no arguments" do
      it "errors if the files are not provided" do
        expect{UserGenerator.load_data}.to raise_error(ArgumentError)
      end
    end

    context "given first names, last names, and locations" do
      it "returns the each of these and a list of words in the computer's dictionary" do
        @ppl = [["John", "M"],
                ["Jane", "F"]]
        @last = ["Doe","Dough"]
        @loc = [["Portland","Oregon"],
                ["Tacoma","Washington"]]
        @users = UserGenerator.load_data fn: @ppl, ln: @last, geo: @loc
        expect(@users.length).to be 4
        expect(@users[:people][0]).to eq ["John","M"] 
        expect(@users[:last_names][0]).to eq "Doe"
        expect(@users[:locations][0]).to eq ["Portland","Oregon"]
        expect(@users[:words]).not_to eq nil
      end
    end
  end
end
