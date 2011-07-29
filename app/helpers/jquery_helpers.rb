class Main
  module JqueryHelpers
    def jquery(path='/js/jquery.js', version='1.4.3')
      # Grab Google CDN's jQuery; fallback to local if necessary
      url = "http://ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js"
      "<script type='text/javascript' src=\"#{url}\"></script>"+
      "<script>!window.jQuery && document.write('<script src=\"#{path}\"><\\/script>')</script>"
    end

    def jquery_ui(path='/js/jqueryui.js', version='1.8.5')
      url = "http://ajax.googleapis.com/ajax/libs/jqueryui/#{version}/jquery-ui.min.js"
      "<script type='text/javascript' src=\"#{url}\"></script>"+
      "<script>!window.jQuery.ui && document.write('<script src=\"#{path}\"><\\/script>')</script>"
    end
  end

  helpers JqueryHelpers
end
