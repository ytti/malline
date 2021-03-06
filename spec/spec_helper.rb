require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/malline.rb'
include Malline

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

TemplateJunOS = <<EOF
interfaces {
   <% name %> {
     mtu <%if mtu %>;
     description "<%if description %>";
   }
}
EOF
TemplateIOS = <<EOF
interface <% name %>
  description <%if description %>
  mtu <%if mtu %>
  vrf forwarding <%if vrf %>
EOF

ResultJunOS = []
ResultJunOS << <<EOF
interfaces {
   xe-1/2/3 {
     mtu 1500;
     description "K: S-12345 foobar 'quote' xyzzy";
   }
}
EOF
ResultJunOS << <<EOF
interfaces {
   xe-1/2/3 {
     mtu 42;
   }
}
EOF

ResultIOS = []
ResultIOS << <<EOF
interface GigabitEthernet0/42
  description K: S-12345 foobar 'quote' xyzzy
  mtu 1500
  vrf forwarding VRF0001
EOF
ResultIOS << <<EOF
interface GigabitEthernet0/42
  description f00fc7c8
  vrf forwarding xyzzy
EOF


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
