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
    before(:each) do
      @http = mock(Net::HTTP).as_null_object
      Net::HTTP.stub(:new).and_return(@http)
      set_valid_options
      File.stub(:exists?).and_return(true)
      @pbar = mock(ProgressBar).as_null_object
      ProgressBar.stub(:new).and_return(@pbar)
    end

    describe "#run" do
      context "progress bar" do
        it "does not create a progress bar unless requested" do
          uploader = IShack::Uploader.new(@options.merge(:progress => false)  )
          uploader.stub(:upload)
          uploader.stub(:display_results)
          ProgressBar.should_not_receive(:new)
          uploader.run 
        end

        it "creates a progress bar if requested" do
          ProgressBar.should_receive(:new).with(anything(), 2).and_return(@pbar)
          uploader = IShack::Uploader.new(@options.merge(:progress => true))
          uploader.stub(:upload)
          uploader.stub(:display_results)
          @pbar.should_receive(:inc).exactly(2).times
          uploader.run
        end
      end

      it "transloads when the :transload option is set" do
        item = @items.first
        uri = mock(URI::HTTP)

        URI.should_receive(:parse).with(item).and_return(uri)
        uploader = IShack::Uploader.new(@options.merge(:transload => true, :items => [item]))
        uploader.stub(:display_results)
        uploader.should_receive(:transload).with(uri)
        uploader.run
      end

      it "uploads by default" do
        uploader = IShack::Uploader.new(@options.merge(:transload => false))
        uploader.stub(:display_results)
        @items.each {|item| uploader.should_receive(:upload).with(item).ordered}
        uploader.run
      end
    end

    describe "validation" do
      before(:each) do
        set_valid_options
        File.stub(:exists?).and_return(true)
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
        File.stub(:exists?).and_return(false)
        lambda { IShack::Uploader.new(@options.merge(:transload => false)) }.should raise_error(ArgumentError)
      end

      it "accepts valid options" do
        lambda { IShack::Uploader.new(@options) }.should_not raise_error(ArgumentError)
      end
    end
  end

private

  def set_valid_options
    @items = ["whatev.jpg", "thing.gif"]
    @options = {:transload => false, :items => @items, :key => 'secret', :progress => true}
  end
end
