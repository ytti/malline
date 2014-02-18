require_relative 'spec_helper.rb'

class Int
  attr_accessor :name, :mtu, :description, :vrf
  def initialize
    @name = 'xe-1/2/3'
    @mtu = 1500
    @description = 'K: S-12345 foobar \'quote\' xyzzy'
    @vrf = 'VRF0001'
  end
  def get_binding; binding; end
end

describe Compiler do
  #it "can be created with string argument" do
  #  Lexer.new('k').must_be_instance_of Lexer
  #end

  #it "can't be created without an argument" do
  #  ->{Lexer.new}.must_raise ArgumentError
  #end

  it "must pass junos example" do
    int = Int.new
    str = Malline.run TemplateJunOS, int.get_binding
    str.must_equal ResultJunOS[0]
    int.description = nil
    int.mtu = 42
    str = Malline.run TemplateJunOS, int.get_binding
    str.must_equal ResultJunOS[1]
  end

  it "must pass ios example" do
    int = Int.new
    int.name = 'GigabitEthernet0/42'
    str = Malline.run TemplateIOS, int.get_binding
    str.must_equal ResultIOS[0]
    int.description = 'f00fc7c8'
    int.mtu = nil
    int.vrf = 'xyzzy'
    str = Malline.run TemplateIOS, int.get_binding
    str.must_equal ResultIOS[1]
  end
end
