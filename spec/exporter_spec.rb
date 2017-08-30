require './user_generator.rb'
require './exporter.rb'

describe Exporter do
  describe ".convert" do
    context "given data and a format to convert to" do
      before(:context) do
        @data = [{
          first_name: "Test",
          last_name: "Testerton",
          icon: "contact_test_testerton.png",
          email: "test@example.com",
          phone_1: "1-617-187-3688",
          phone_2: "1-850-278-3967",
          phone_3: "1-210-885-9288",
          street: "75474 Fremont Lane",
          city: "Boston",
          state: "Massachusetts",
          initials: "TT"
        }]
      end

      it "converts to qml format when requested" do
        @exported_format = Exporter.convert(
          users: @data, format: 'qml_listelement')
        @target_format = 
        <<-ITEM
ListElement {
  first_name: "Test"
  last_name: "Testerton"
  icon: "contact_test_testerton.png"
  email: "test@example.com"
  phone1: "1-617-187-3688"
  phone2: "1-850-278-3967"
  phone3: "1-210-885-9288"
  street: "75474 Fremont Lane"
  city: "Boston"
  state: "Massachusetts"
  initials: "TT"
}
        ITEM

        expect(@exported_format).to eq @target_format
      end
    end
  end
end
