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
          initials: "TT",
          gender: "M"
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

  describe ".export" do
    context "given a filename, users, source images, and target format" do
      before(:context) do
        @users_list = [
          {
            first_name: "Test",
            last_name: "Testerton",
            icon: "contact_test_testerton.jpg",
            email: "test@example.com",
            phone_1: "1-617-187-3688",
            phone_2: "1-850-278-3967",
            phone_3: "1-210-885-9288",
            street: "75474 Fremont Lane",
            city: "Boston",
            state: "Massachusetts",
            initials: "TT",
            gender: "M"
          },
          {
            first_name: "Samantha",
            last_name: "Sample",
            icon: "contact_samantha_sample.jpg",
            email: "sam.sample@example.com",
            phone_1: "1-123-456-7890",
            phone_2: "1-456-789-0123",
            phone_3: "1-789-012-3456",
            street: "5021 Portland St",
            city: "Tacoma",
            state: "Washington",
            initials: "SS",
            gender: "F"
          }]

        Exporter.export(
          filename: "my_users",
          users:    @users_list,
          source_images: "src_pics",
          target_format: "qml_listelement")
      end

      it "creates a file based on the provided filename" do
        @file = File.file?("my_users")
        expect(@file).to be TRUE
      end

      it "creates a folder of images" do
        @folder = File.directory?("my_users_images")
        @files = File.file?("my_users_images/contact_test_testerton.jpg")

        expect(@folder).to be TRUE
        expect(@files).to be TRUE
      end

      after(:context) do
        FileUtils.rm_rf("my_users_images")
        File.delete("my_users")
      end
    end
  end
end
