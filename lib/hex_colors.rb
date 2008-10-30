module HexColors
  def hex_colors(*symbols)
    symbols.each do |symbol|
      class_eval <<-EOS, __FILE__, __LINE__
        def #{symbol}_hex
          if value_or_default(:#{symbol}) =~ /^(0x|#)([0-9A-Fa-f]{3,6})/
            "#" + $2
          end
        end
        def #{symbol}_hex=(input)
          if input =~ /^(0x|#)([0-9A-Fa-f]{3,6})/
            self[:#{symbol}] = "0x" + $2
          end
        end
      EOS
    end
  end
  def value_or_default(column)
    defaults = {
      :bg => "0xf8f8f8",
      :leftbg => "0xeeeeee",
      :lefticon => "0x666666",
      :rightbg => "0xcccccc",
      :rightbghover => "0x999999",
      :righticon => "0x666666",
      :righticonhover => "0xffffff",
      :text => "0x666666",
      :slider => "0x666666",
      :track => "0xFFFFFF",
      :border => "0x666666",
      :loader => "0x9FFFB8"
    }
    if value = self[column] and !value.blank?
      value
    else
      defaults[column]
    end
  end
end