require_relative 'spec_helper.rb'
describe Lexer do
  it "can be created with string argument" do
    Lexer.new('k').must_be_instance_of Lexer
  end

  it "can't be created without an argument" do
    ->{Lexer.new}.must_raise ArgumentError
  end

  it "must lex correctly" do
    # yeah bit of a cope out :)
    TEST.each do |tst|
      lex = Lexer.new tst[:string]
      ary, token = [], nil
      ary << token while token = lex.next_token
      ary.must_equal tst[:lex]
    end
  end

  describe '#line' do
    it 'must not consider trailing \n as new line' do
      lex = Lexer.new "foo\n"
      ss = lex.instance_variable_get :@ss
      ss.scan_until(/.*/m)
      lex.line.must_equal 1
    end
  end
end
