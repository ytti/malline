# Malline

Malline is template engine targeting IOS/JunOS or generally configurations (or
more accurately what ever text stuff I'm doing).

It surfaced from the need to do something like this in ERB:
```
interfaces {
  <%= name %> {
    description "<%if description %>";
  }
}
```

where description "description"; is only output if the code evaluates true,
keeping the template clean in common use-case

```
Consider this code
require_relative './lib/malline'
require 'pry'
class Int
  attr_accessor :name, :mtu, :description, :poop
  def initialize
    @name = 'xe-1/2/3.42'
    @mtu = 1500
    @description = 'K: S-123455 - poop customer'
    @poop = true
  end
  def get_binding
    binding
  end
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
```

Real use might look something like this:
```
[1] pry(main)> puts cfg
interfaces {
   xe-1/2/3.42 {
     mtu 1500;
     description "K: S-123455 - poop customer";
   }
}
=> nil
[2] pry(main)> int.mtu = 900
=> 900
[3] pry(main)> int.description = nil
=> nil
[4] pry(main)> puts Malline.run template, int.get_binding
interfaces {
   xe-1/2/3.42 {
     mtu 900;
   }
}
=> nil
```



