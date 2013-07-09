class Klass
  include HstoreMethods
  def self.scope(*args); end
  def self.attr_accessible(*args); end
end
describe HstoreMethods do
  it "should define some boolean methods" do
    Klass.define_boolean(:a, :b)
    c = Klass.new
    c.should respond_to(:a)
  end

  it "also shoudl define integer method" do
    Klass.define_integer(:int)
    c = Klass.new
    c.should respond_to(:int)
  end

  it "should define string" do
    Klass.define_string(:str)
    c = Klass.new
    c.should respond_to(:str)
  end
end
