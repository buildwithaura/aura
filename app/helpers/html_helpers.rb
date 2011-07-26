class Main
  module HtmlHelpers
    # Helper: html (Helpers)
    # Sanitizes HTML with Markdown and Textile support.
    #
    def html(str)
      str = str.strip

      if str =~ /^\s*<textile>(.*?)(<\/textile>)?\s*$/
        str = Tilt.new('textile') { $1 }.render
      elsif str =~ /^\s*<markdown>(.*?)(<\/markdown>)?\s*$/
        str = Tilt.new('markdown') { $1 }.render
      end

      str.strip
    end
  end

  helpers HtmlHelpers
end
