class Main
  module HtmlHelpers
    # Helper: html (Helpers)
    # Sanitizes HTML with Markdown and Textile support.
    #
    def html(string)
      require 'nokogiri'

      doc = Nokogiri.HTML(string)

      # Convert textile/markdown
      %w(textile markdown).each do |type|
        doc.css("[format='#{type}'], #{type}").each do |el|
          el.after(Tilt.new(type) { el.inner_html }.render)
          el.remove
        end
      end

      # Stupidity
      doc.css('p:empty').each { |el| el.remove }

      doc.at_css('body').inner_html.strip
    end
  end

  helpers HtmlHelpers
end
