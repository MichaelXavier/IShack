require 'spec/spec_helper'

describe IShack::ImageTuple do
  before(:each) do
    @origin, @link = mock(), mock()
  end
  subject { IShack::ImageTuple.new(@origin, @link) }

  it { should respond_to(:origin) } 
  it { should respond_to(:link) } 
end
