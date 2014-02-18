module Malline
  class Compiler
    VAR = '_malline_'
    OUT = VAR + '_out'
    class InvalidKind < NameError; end
    attr_reader :out
    def initialize parsed
      @parsed = parsed
      @out = nil
      @cmd = {
        :if => {
          :now  => 0,
          :line => [],
          :id   => [],
        },
      }
    end

    def compile
      @out = resolve(combine)
    end

    def combine
      out = []
      @parsed.each do |e|
        case kind=e.shift
        when :data then data(out, *e)
        when :code then code(out, *e)
        else
          raise InvalidKind, "'#{kind}' was not recognized"
        end
      end
      out
    end

    def data out, str, lines
      lines = (lines.first .. lines.last).to_a
      str.lines.each_with_index do |line, index|
        linenr = lines[index]
        line = '%s.concat \'%s\'' % [OUT, line.gsub(/'/, %q(\\\'))]
        out << [line, linenr]
      end
    end

    def code out, cmd, str, lines
      lines = (lines.first .. lines.last).to_a
      str.lines.each_with_index do |line, index|
        linenr = lines[index]
        line = cmd_if(line, lines, @cmd[:if][:now]+=1) if cmd == :if
        line = '%s.concat %s' % [OUT, line] unless cmd == :s
        out << ["#{line}.to_s", linenr]
      end
    end


    def cmd_if str, lines, id
      name = VAR+'if_'+id.to_s
      (lines.first .. lines.last).each do |line|
        @cmd[:if][:line][line] ||= []
        @cmd[:if][:line][line] << id
        @cmd[:if][:id][id] = [name, str]
      end
      name
    end

    def resolve out_org
      out = ["#{OUT}='';"]
      cmp = []
      seen = []
      out_org.each do |line, line_nr|
        resolve_cmd_if(line_nr, cmp, out) unless seen.include? line_nr
        seen << line_nr
        if not cmp.empty?
          line = line + ' if ' + cmp.join(' and ')
        end
        out << line + ';'
      end
      out << "#{OUT}"
      out.join "\n"
    end

    def resolve_cmd_if line_nr, cmp, out
      cmp.clear
      set = []
      [@cmd[:if][:line][line_nr]].flatten.compact.each do |cmd_id|
        varname, varvalue = @cmd[:if][:id][cmd_id]
        set << [varname,varvalue]
        cmp << varname
      end
      set.each do |name, value|
        out << name + '=' + value + ';'
      end
    end
  end
end
