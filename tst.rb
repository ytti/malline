#!/usr/bin/env ruby

require_relative './lib/malline'
require 'pry'
class Int
  attr_accessor :name, :mtu, :description, :poop
  def initialize
    @name        = 'xe-1/2/3.42'
    @mtu         = 1500
    @description = 'K: S-123455 - poop customer'
  end
  def get_binding; binding; end
end

template = <<EOF
interfaces {
   <% name %> {
     mtu <%if mtu %>;
     description "<%if description %>";
   }
}
EOF

int = Int.new
cfg = Malline.run template, int.get_binding
binding.pry
