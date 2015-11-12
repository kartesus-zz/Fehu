require 'kpeg/compiled_parser'

class Fehu::Parser < KPeg::CompiledParser


  attr_accessor :ast

  def initialize(*args)
    super
    @ast = [:module, []]
  end

  def add(node)
    @ast = [:module, @ast.last.push(node)]
  end


  # :stopdoc:

  # eof = !.
  def _eof
    _save = self.pos
    _tmp = get_byte
    _tmp = _tmp ? nil : true
    self.pos = _save
    set_failed_rule :_eof unless _tmp
    return _tmp
  end

  # space = (" " | "\t")
  def _space

    _save = self.pos
    while true # choice
      _tmp = match_string(" ")
      break if _tmp
      self.pos = _save
      _tmp = match_string("\t")
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # nl = ("\n" | ";")
  def _nl

    _save = self.pos
    while true # choice
      _tmp = match_string("\n")
      break if _tmp
      self.pos = _save
      _tmp = match_string(";")
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_nl unless _tmp
    return _tmp
  end

  # sp = space+
  def _sp
    _save = self.pos
    _tmp = apply(:_space)
    if _tmp
      while true
        _tmp = apply(:_space)
        break unless _tmp
      end
      _tmp = true
    else
      self.pos = _save
    end
    set_failed_rule :_sp unless _tmp
    return _tmp
  end

  # - = space*
  def __hyphen_
    while true
      _tmp = apply(:_space)
      break unless _tmp
    end
    _tmp = true
    set_failed_rule :__hyphen_ unless _tmp
    return _tmp
  end

  # brsp = (space | nl)*
  def _brsp
    while true

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_space)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_nl)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      break unless _tmp
    end
    _tmp = true
    set_failed_rule :_brsp unless _tmp
    return _tmp
  end

  # eoe = - (comment | nl) brsp
  def _eoe

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_comment)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_nl)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_brsp)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_eoe unless _tmp
    return _tmp
  end

  # literal = (tagged_value | tag | float | int | string | atom)
  def _literal

    _save = self.pos
    while true # choice
      _tmp = apply(:_tagged_value)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_tag)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_float)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_int)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_string)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_atom)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_literal unless _tmp
    return _tmp
  end

  # pipe = (pipe:a brsp ">" - call:b { [:call, b, a] } | call:a brsp ">" - call:b { [:call, b, a] })
  def _pipe

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_pipe)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_brsp)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(">")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_call)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [:call, b, a] ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_call)
        a = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_brsp)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string(">")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_call)
        b = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [:call, b, a] ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_pipe unless _tmp
    return _tmp
  end

  # bind = atom:a - "=" - call:c { [:bind, a, c] }
  def _bind

    _save = self.pos
    while true # sequence
      _tmp = apply(:_atom)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("=")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_call)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:bind, a, c] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_bind unless _tmp
    return _tmp
  end

  # expr = (pipe | call | lambda)
  def _expr

    _save = self.pos
    while true # choice
      _tmp = apply(:_pipe)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_call)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_lambda)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_expr unless _tmp
    return _tmp
  end

  # top = (bind:b {add(b)} | expr:e {add(e)})
  def _top

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_bind)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin; add(b); end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_expr)
        e = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; add(e); end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_top unless _tmp
    return _tmp
  end

  # module = (comment | top eoe)+
  def _module
    _save = self.pos

    _save1 = self.pos
    while true # choice
      _tmp = apply(:_comment)
      break if _tmp
      self.pos = _save1

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_top)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_eoe)
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save1
      break
    end # end choice

    if _tmp
      while true

        _save3 = self.pos
        while true # choice
          _tmp = apply(:_comment)
          break if _tmp
          self.pos = _save3

          _save4 = self.pos
          while true # sequence
            _tmp = apply(:_top)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_eoe)
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save3
          break
        end # end choice

        break unless _tmp
      end
      _tmp = true
    else
      self.pos = _save
    end
    set_failed_rule :_module unless _tmp
    return _tmp
  end

  # root = eoe* module brsp eof
  def _root

    _save = self.pos
    while true # sequence
      while true
        _tmp = apply(:_eoe)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_module)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_brsp)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_eof)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_root unless _tmp
    return _tmp
  end

  # comment = "--" (!nl .)* nl
  def _comment

    _save = self.pos
    while true # sequence
      _tmp = match_string("--")
      unless _tmp
        self.pos = _save
        break
      end
      while true

        _save2 = self.pos
        while true # sequence
          _save3 = self.pos
          _tmp = apply(:_nl)
          _tmp = _tmp ? nil : true
          self.pos = _save3
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = get_byte
          unless _tmp
            self.pos = _save2
          end
          break
        end # end sequence

        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_nl)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_comment unless _tmp
    return _tmp
  end

  # name = < /[a-z][a-z\-]*/ > { text }
  def _name

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[a-z][a-z\-]*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_name unless _tmp
    return _tmp
  end

  # atom = name:n { [:atom, n.to_sym] }
  def _atom

    _save = self.pos
    while true # sequence
      _tmp = apply(:_name)
      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:atom, n.to_sym] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_atom unless _tmp
    return _tmp
  end

  # number = < ("0" | /[1-9][0-9]*/) > { text }
  def _number

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # choice
        _tmp = match_string("0")
        break if _tmp
        self.pos = _save1
        _tmp = scan(/\A(?-mix:[1-9][0-9]*)/)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_number unless _tmp
    return _tmp
  end

  # int = number:n { [:int, n.to_i] }
  def _int

    _save = self.pos
    while true # sequence
      _tmp = apply(:_number)
      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:int, n.to_i] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_int unless _tmp
    return _tmp
  end

  # float = number:w "." number:f { [:float, "#{w}.#{f}".to_f] }
  def _float

    _save = self.pos
    while true # sequence
      _tmp = apply(:_number)
      w = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(".")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_number)
      f = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:float, "#{w}.#{f}".to_f] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_float unless _tmp
    return _tmp
  end

  # tag = ":" name:n { [:tag, n] }
  def _tag

    _save = self.pos
    while true # sequence
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_name)
      n = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:tag, n] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_tag unless _tmp
    return _tmp
  end

  # tagged_value = (tag:t (space call)+:l { t.concat(l) } | "(" - tagged_value:t - ")" { t })
  def _tagged_value

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_tag)
        t = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _ary = []

        _save3 = self.pos
        while true # sequence
          _tmp = apply(:_space)
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_call)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        if _tmp
          _ary << @result
          while true

            _save4 = self.pos
            while true # sequence
              _tmp = apply(:_space)
              unless _tmp
                self.pos = _save4
                break
              end
              _tmp = apply(:_call)
              unless _tmp
                self.pos = _save4
              end
              break
            end # end sequence

            _ary << @result if _tmp
            break unless _tmp
          end
          _tmp = true
          @result = _ary
        else
          self.pos = _save2
        end
        l = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  t.concat(l) ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save5 = self.pos
      while true # sequence
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_tagged_value)
        t = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin;  t ; end
        _tmp = true
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_tagged_value unless _tmp
    return _tmp
  end

  # num_escapes = (< /[0-7]{1,3}/ > { [text.to_i(8)].pack("U") } | "x" < /[a-f\d]{2}/i > { [text.to_i(16)].pack("U") })
  def _num_escapes

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = scan(/\A(?-mix:[0-7]{1,3})/)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [text.to_i(8)].pack("U") ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = match_string("x")
        unless _tmp
          self.pos = _save2
          break
        end
        _text_start = self.pos
        _tmp = scan(/\A(?i-mx:[a-f\d]{2})/)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [text.to_i(16)].pack("U") ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_num_escapes unless _tmp
    return _tmp
  end

  # string_escapes = ("n" { "\n" } | "s" { " " } | "r" { "\r" } | "t" { "\t" } | "v" { "\v" } | "f" { "\f" } | "b" { "\b" } | "a" { "\a" } | "e" { "\e" } | "\\" { "\\" } | "\"" { "\"" } | num_escapes | < . > { text })
  def _string_escapes

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("n")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  "\n" ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = match_string("s")
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  " " ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = match_string("r")
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  "\r" ; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = match_string("t")
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  "\t" ; end
        _tmp = true
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save5 = self.pos
      while true # sequence
        _tmp = match_string("v")
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin;  "\v" ; end
        _tmp = true
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save6 = self.pos
      while true # sequence
        _tmp = match_string("f")
        unless _tmp
          self.pos = _save6
          break
        end
        @result = begin;  "\f" ; end
        _tmp = true
        unless _tmp
          self.pos = _save6
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save7 = self.pos
      while true # sequence
        _tmp = match_string("b")
        unless _tmp
          self.pos = _save7
          break
        end
        @result = begin;  "\b" ; end
        _tmp = true
        unless _tmp
          self.pos = _save7
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save8 = self.pos
      while true # sequence
        _tmp = match_string("a")
        unless _tmp
          self.pos = _save8
          break
        end
        @result = begin;  "\a" ; end
        _tmp = true
        unless _tmp
          self.pos = _save8
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save9 = self.pos
      while true # sequence
        _tmp = match_string("e")
        unless _tmp
          self.pos = _save9
          break
        end
        @result = begin;  "\e" ; end
        _tmp = true
        unless _tmp
          self.pos = _save9
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save10 = self.pos
      while true # sequence
        _tmp = match_string("\\")
        unless _tmp
          self.pos = _save10
          break
        end
        @result = begin;  "\\" ; end
        _tmp = true
        unless _tmp
          self.pos = _save10
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save11 = self.pos
      while true # sequence
        _tmp = match_string("\"")
        unless _tmp
          self.pos = _save11
          break
        end
        @result = begin;  "\"" ; end
        _tmp = true
        unless _tmp
          self.pos = _save11
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_num_escapes)
      break if _tmp
      self.pos = _save

      _save12 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = get_byte
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save12
          break
        end
        @result = begin;  text ; end
        _tmp = true
        unless _tmp
          self.pos = _save12
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_string_escapes unless _tmp
    return _tmp
  end

  # string_seq = < /[^\\"]+/ > { text }
  def _string_seq

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[^\\"]+)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_string_seq unless _tmp
    return _tmp
  end

  # string_body = ("\\" string_escapes:s | string_seq:s)*:ary { Array(ary) }
  def _string_body

    _save = self.pos
    while true # sequence
      _ary = []
      while true

        _save2 = self.pos
        while true # choice

          _save3 = self.pos
          while true # sequence
            _tmp = match_string("\\")
            unless _tmp
              self.pos = _save3
              break
            end
            _tmp = apply(:_string_escapes)
            s = @result
            unless _tmp
              self.pos = _save3
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save2
          _tmp = apply(:_string_seq)
          s = @result
          break if _tmp
          self.pos = _save2
          break
        end # end choice

        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      ary = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  Array(ary) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_string_body unless _tmp
    return _tmp
  end

  # string = "\"" string_body:s "\"" { [:string, s.join] }
  def _string

    _save = self.pos
    while true # sequence
      _tmp = match_string("\"")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_string_body)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("\"")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:string, s.join] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_string unless _tmp
    return _tmp
  end

  # parameters = expr:h (brsp expr)*:t { [h] + t }
  def _parameters

    _save = self.pos
    while true # sequence
      _tmp = apply(:_expr)
      h = @result
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true

        _save2 = self.pos
        while true # sequence
          _tmp = apply(:_brsp)
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = apply(:_expr)
          unless _tmp
            self.pos = _save2
          end
          break
        end # end sequence

        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      t = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [h] + t ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_parameters unless _tmp
    return _tmp
  end

  # call = ("[" (atom | lambda):a brsp parameters:b - "]" { [:call, a, b] } | literal)
  def _call

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save1
          break
        end

        _save2 = self.pos
        while true # choice
          _tmp = apply(:_atom)
          break if _tmp
          self.pos = _save2
          _tmp = apply(:_lambda)
          break if _tmp
          self.pos = _save2
          break
        end # end choice

        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_brsp)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_parameters)
        b = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("]")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [:call, a, b] ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_literal)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_call unless _tmp
    return _tmp
  end

  # arguments = literal:h (sp literal)*:t { [h] + t }
  def _arguments

    _save = self.pos
    while true # sequence
      _tmp = apply(:_literal)
      h = @result
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true

        _save2 = self.pos
        while true # sequence
          _tmp = apply(:_sp)
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = apply(:_literal)
          unless _tmp
            self.pos = _save2
          end
          break
        end # end sequence

        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      t = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [h] + t ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_arguments unless _tmp
    return _tmp
  end

  # lambda = "[" sp arguments:a sp "->" sp expr:b sp "]" { [:lambda, a, b] }
  def _lambda

    _save = self.pos
    while true # sequence
      _tmp = match_string("[")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_sp)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_arguments)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_sp)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("->")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_sp)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_expr)
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_sp)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("]")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [:lambda, a, b] ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_lambda unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:_eof] = rule_info("eof", "!.")
  Rules[:_space] = rule_info("space", "(\" \" | \"\\t\")")
  Rules[:_nl] = rule_info("nl", "(\"\\n\" | \";\")")
  Rules[:_sp] = rule_info("sp", "space+")
  Rules[:__hyphen_] = rule_info("-", "space*")
  Rules[:_brsp] = rule_info("brsp", "(space | nl)*")
  Rules[:_eoe] = rule_info("eoe", "- (comment | nl) brsp")
  Rules[:_literal] = rule_info("literal", "(tagged_value | tag | float | int | string | atom)")
  Rules[:_pipe] = rule_info("pipe", "(pipe:a brsp \">\" - call:b { [:call, b, a] } | call:a brsp \">\" - call:b { [:call, b, a] })")
  Rules[:_bind] = rule_info("bind", "atom:a - \"=\" - call:c { [:bind, a, c] }")
  Rules[:_expr] = rule_info("expr", "(pipe | call | lambda)")
  Rules[:_top] = rule_info("top", "(bind:b {add(b)} | expr:e {add(e)})")
  Rules[:_module] = rule_info("module", "(comment | top eoe)+")
  Rules[:_root] = rule_info("root", "eoe* module brsp eof")
  Rules[:_comment] = rule_info("comment", "\"--\" (!nl .)* nl")
  Rules[:_name] = rule_info("name", "< /[a-z][a-z\\-]*/ > { text }")
  Rules[:_atom] = rule_info("atom", "name:n { [:atom, n.to_sym] }")
  Rules[:_number] = rule_info("number", "< (\"0\" | /[1-9][0-9]*/) > { text }")
  Rules[:_int] = rule_info("int", "number:n { [:int, n.to_i] }")
  Rules[:_float] = rule_info("float", "number:w \".\" number:f { [:float, \"\#{w}.\#{f}\".to_f] }")
  Rules[:_tag] = rule_info("tag", "\":\" name:n { [:tag, n] }")
  Rules[:_tagged_value] = rule_info("tagged_value", "(tag:t (space call)+:l { t.concat(l) } | \"(\" - tagged_value:t - \")\" { t })")
  Rules[:_num_escapes] = rule_info("num_escapes", "(< /[0-7]{1,3}/ > { [text.to_i(8)].pack(\"U\") } | \"x\" < /[a-f\\d]{2}/i > { [text.to_i(16)].pack(\"U\") })")
  Rules[:_string_escapes] = rule_info("string_escapes", "(\"n\" { \"\\n\" } | \"s\" { \" \" } | \"r\" { \"\\r\" } | \"t\" { \"\\t\" } | \"v\" { \"\\v\" } | \"f\" { \"\\f\" } | \"b\" { \"\\b\" } | \"a\" { \"\\a\" } | \"e\" { \"\\e\" } | \"\\\\\" { \"\\\\\" } | \"\\\"\" { \"\\\"\" } | num_escapes | < . > { text })")
  Rules[:_string_seq] = rule_info("string_seq", "< /[^\\\\\"]+/ > { text }")
  Rules[:_string_body] = rule_info("string_body", "(\"\\\\\" string_escapes:s | string_seq:s)*:ary { Array(ary) }")
  Rules[:_string] = rule_info("string", "\"\\\"\" string_body:s \"\\\"\" { [:string, s.join] }")
  Rules[:_parameters] = rule_info("parameters", "expr:h (brsp expr)*:t { [h] + t }")
  Rules[:_call] = rule_info("call", "(\"[\" (atom | lambda):a brsp parameters:b - \"]\" { [:call, a, b] } | literal)")
  Rules[:_arguments] = rule_info("arguments", "literal:h (sp literal)*:t { [h] + t }")
  Rules[:_lambda] = rule_info("lambda", "\"[\" sp arguments:a sp \"->\" sp expr:b sp \"]\" { [:lambda, a, b] }")
  # :startdoc:
end