class Message
  def send
    provider
  end
end

class Multiposter

end

describe "description" do
  it "should use appropriate strategy when sending message" do
    mess = Message.new
    mess.stub(:provider).and_return("crap")
    mess.send.should == 'crap'
  end

  it "should send message"
end
