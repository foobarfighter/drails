require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Drails::Installer do
  attr_reader :installer, :rails_root, :drails_root

  before do
    @rails_root = File.join(File.dirname(__FILE__), "../testapp")
    @drails_root = File.join(File.dirname(__FILE__), "../")
  end

  describe "#initialize" do
    it "sets the #drails_root to the same directory that it was passed" do
      root_dir = File.dirname(__FILE__)
    end
  end

  describe "#require_rails" do

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
    before do
      @installer = Drails::Installer.new(rails_root, drails_root)
    end

    describe "when it finds dojo_pkg" do
      it "returns true" do
        mock(Kernel).require('dojo-pkg') { true }
        installer.require_dojo_pkg.should be_true
      end
    end

    describe "when it can't find dojo_pkg" do
      it "returns false" do
        mock(Kernel).require('dojo-pkg') { raise LoadError.new }
        installer.require_dojo_pkg.should be_false
      end
    end
  end


  describe "#require_prerequisites!" do
    before do
      @installer = Drails::Installer.new(rails_root, drails_root)
    end

    describe "when it fails" do
      it "dies with an error message notifying the user" do
        mock(installer).require_dojo_pkg { false }
        mock(installer).die_with_message(Drails::Installer::REQUIRE_PREREQUISITES_ERROR)
        installer.require_prerequisites!
      end
    end

    describe "install is successful" do
      it "notifies the user of success"
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
  end

  describe "#install_dojo_source" do
    describe "when it fails" do
      before do
        @installer = Drails::Installer.new('somedirthatshouldntexist', 'someotherdirthatshouldntexist')
      end

      it "raises an error" do
        lambda {
          installer.install_dojo_source
        }.should raise_error
      end
    end

    describe "when it succeeds" do
      before do
        @installer = Drails::Installer.new(rails_root, drails_root)
        require 'dojo-pkg'
        mock.instance_of(Dojo::Commands::Dojofy).install { true }
      end

      it "returns" do
        installer.install_dojo_source
      end
    end
  end

  describe "#install_drails_scripts" do
    describe "when it fails" do
      before do
        @installer = Drails::Installer.new('somedirthatshouldntexist', 'someotherdirthatshouldntexist')
      end

      it "raises an error" do
        lambda {
          installer.install_drails_scripts
        }.should_not raise_error
      end
    end

    describe "when it succeeds" do
      attr_reader :drails_scripts_dest_dir
      before do
        @drails_scripts_dest_dir = File.join(installer.dojo_dest_dir, 'drails')
        @installer = Drails::Installer.new(rails_root, drails_root)
      end

      after do
        require 'fileutils'
        FileUtils::rm_r drails_scripts_dest_dir
      end
      it "copys the drails scripts to the installer#dojo_dest_dir" do
        installer.install_drails_scripts
        File.directory?(File.join(installer.dojo_dest_dir, 'drails'))
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