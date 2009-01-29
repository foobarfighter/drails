require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Drails::Installer do
  attr_reader :installer

  describe "#initialize" do
    it "sets the #drails_root to the same directory that it was passed" do
      root_dir = File.dirname(__FILE__)
    end
  end

  describe "#require_rails" do
    attr_reader :rails_root, :drails_root
    before do
      @rails_root = File.join(File.dirname(__FILE__), "../../testapp")
      @drails_root = File.join(File.dirname(__FILE__), "../../")
    end

    describe "when it finds the rails_root" do
      it "returns true" do
        File.directory?(rails_root).should be_true
        File.exists?(drails_root).should be_true

        @installer = Drails::Installer.new(rails_root, drails_root)
        installer.require_rails.should be_true
      end
    end

    describe "when it can't find the rails_root" do
      it "returns false" do
        @installer = Drails::Installer.new("some directory that doesnt exist", drails_root)
        installer.require_rails.should be_false
      end
    end
  end

  describe "#require_dojo_pkg" do
    describe "when it finds dojo_pkg" do
      it "returns true"
    end

    describe "when it can't find dojo_pkg" do
      it "returns false"
    end
  end


  describe "#require_prerequisites!" do
    describe "when it fails" do
      it "dies with an error message notifying the user"
    end
  end

  describe "#install!" do
    describe "when Drails::Installer attempts to install dojo sources" do
      describe "an error occurs" do
        it "dies with an error message notifying the user"
      end

      describe "install is successful" do
        it "notifies the user of success"
      end
    end

    describe "when Drails::Installer attempts to install the d-rails sources" do
      describe "an error occurs" do
        it "dies with an error message notifying the user"
      end

      describe "install is successful" do
        it "notifies the user of success"
      end
    end
  end

  describe "#die_with_message" do
    attr_reader :msg, :temp_file, :stderr_fileno

    before do
      @installer = Drails::Installer.new('.', '.')
      @msg = "Umm... dammit, I croaked"
      @temp_file = Tempfile.open("drails_installer_spec")
      @stderr_fileno = $stderr.fileno
      $stderr.reopen(temp_file)
      mock(Kernel).exit(1) { true }
    end

    after do
      $stderr = IO.for_fd(stderr_fileno, "w")
      temp_file.close!
    end

    it "warns the user with an error message and calls exit" do
      installer.die_with_message(msg)
      temp_file.size.should > 0
    end

  end
end