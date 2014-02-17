class Malline::Parser
token START_CODE END_CODE DATA CMD
rule
  values
    : values value
    | value
    ;
  value
    : code_block
    | data
    ;
  code_block
    : START_CODE END_CODE
    | START_CODE CMD DATA END_CODE { @handler.code(val[2], val[1].to_sym) }
    | START_CODE DATA END_CODE     { @handler.code val[1] }
    ;
  data : DATA { @handler.data val.first }

end

---- inner

require_relative 'handler'

def initialize lexer, handler=Handler.new
  @lexer   = lexer
  @handler = handler
  super()
end

def next_token
  token, string, start_line, end_line = @lexer.next_token
  @handler.token_line = [start_line, end_line]
  [token, string] if token
end

def parse
  do_parse
  @handler
end
