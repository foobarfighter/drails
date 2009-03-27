describe Drails do
  it "reports the correct version information" do
    expected_version_string = "1.0.1"
    Drails::VERSION::STRING.should == expected_version_string
    expected_version_array = expected_version_string.split(".").collect { |part| part.to_i }
    Drails::VERSION::MAJOR.should == expected_version_array[0]
    Drails::VERSION::MINOR.should == expected_version_array[1]
    Drails::VERSION::TINY.should == expected_version_array[2]
  end
end