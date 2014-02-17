require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/malline.rb'
include Malline

TEST = [

{
:string => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
:lex => [[:DATA, "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 1, 1]],
:parsed => [[:data, "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", [1, 1]]],
},

{
:string => "Lorem ipsum <%dolor sit amet%>, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
:lex => [[:DATA, "Lorem ipsum ", 1, 1], [:START_CODE, "<%", 1, 1], [:DATA, "dolor sit amet", 1, 1], [:END_CODE, "%>", 1, 1], [:DATA, ", consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 1, 1]],
:parsed => [[:data, "Lorem ipsum ", [1, 1]], [:code, nil, "dolor sit amet", [1, 1]], [:data, ", consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", [1, 1]]],
},

{
:string => "Lorem ipsum <%dolor\nsit amet%>, con\nsectetur <%if testing\n bar\n fooi %> adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
:lex => [[:DATA, "Lorem ipsum ", 1, 1], [:START_CODE, "<%", 1, 1], [:DATA, "dolor\nsit amet", 1, 2], [:END_CODE, "%>", 1, 2], [:DATA, ", con\nsectetur ", 2, 3], [:START_CODE, "<%if", 2, 3], [:CMD, "if", 2, 3], [:DATA, " testing\n bar\n fooi ", 3, 5], [:END_CODE, "%>", 3, 5], [:DATA, " adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 5, 5]],
:parsed => [[:data, "Lorem ipsum ", [1, 1]], [:code, nil, "dolor\nsit amet", [1, 2]], [:data, ", con\nsectetur ", [2, 3]], [:code, :if, " testing\n bar\n fooi ", [3, 5]], [:data, " adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", [5, 5]]],
},

]
