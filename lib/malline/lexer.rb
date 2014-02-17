require 'strscan'
require 'stringio'

module Malline
  class Lexer
    TOKEN = {
      :START_CODE => /<%(if|s)?/,
      :END_CODE   => /%>/,
    }

    def initialize io
      io  = StringIO.new io if io.class == String
      @ss = StringScanner.new io.read
      @token, @state = [], [:CODE, :DATA]
    end

    def next_token
      return @token.shift unless @token.empty?
      return if @ss.eos?

      start = line
      name = @state.rotate!.first == :DATA ? :START_CODE : :END_CODE
      if data = @ss.scan_until(TOKEN[name])
        @token << [name, @ss.matched, start, line]
        @token << [:CMD, @ss.matched[2..-1], start, line] if @ss.matched.size > 2
        [:DATA, data[0..-(@ss.matched.size+1)], start, line]
      else #gobble gobble gobble
        [:DATA, @ss.scan(/.*/m), start, line]
      end
    end

    def line
      @ss.string[0..@ss.pos].count("\n")+1
    end
  end
end
