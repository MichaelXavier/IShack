require 'spec/spec_helper'

describe IShack::Uploader do
  context "class" do
    subject { IShack::Uploader }

    describe "::api_uri" do
      it "returns a URI::HTTP instance" do
        subject.api_uri.should be_instance_of(URI::HTTP)       
      end
    end
  end

  context "instance" do
    describe "validation" do
      before(:all) do
        @item = "whatev.jpg"
        @options = {:transload => false, :items => [@item], :key => 'secret'}
      end
      it "requires at least one thing being uploaded" do
        lambda { IShack::Uploader.new(@options.merge(:items => [])) }.should raise_error(ArgumentError)
      end

      it "rejects a nil api key" do
        lambda { IShack::Uploader.new(@options.merge(:key => nil)) }.should raise_error(ArgumentError)
      end

      it "rejects a blank api key" do
        lambda { IShack::Uploader.new(@options.merge(:key => "")) }.should raise_error(ArgumentError)
      end

      it "requires non-transloaded items to exist" do
        File.should_receive(:exists?).with(@item).and_return(false)
        lambda { IShack::Uploader.new(@options) }.should raise_error(ArgumentError)
      end

      it "accepts valid options" do
        File.stub(:exists?).and_return(true)
        lambda { IShack::Uploader.new(@options) }.should_not raise_error(ArgumentError)
      end
    end
  end

end
