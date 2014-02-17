module Malline
  require_relative './malline/lexer'
  require_relative './malline/parser'
  require_relative './malline/compiler.rb'

  def self.run template, binding
    lex = Lexer.new template
    par = Parser.new lex
    han = par.parse
    com = Compiler.new han.parsed
    template = com.compile
    eval(template, binding)
  end
end
