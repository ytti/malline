module Malline
  class Handler
    attr_reader :parsed
    attr_accessor :token_line
    def initialize
      @parsed = []
    end

    def code string, cmd=nil
      @parsed << [:code, cmd, string, token_line]
    end

    def data string
      @parsed << [:data, string, token_line]
    end
  end
end
