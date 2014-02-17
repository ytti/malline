require_relative 'spec_helper.rb'

def get_handler string
  lex = Lexer.new string
  par = Parser.new lex
  par.parse
end

describe Handler do

  it "can be created" do
    Handler.new.must_be_instance_of Handler
  end

  it "must get correctly parsed data" do
    # yeah bit of a cope out :)
    TEST.each do |tst|
      han = get_handler tst[:string]
      han.parsed.must_equal tst[:parsed]
    end
  end
end
