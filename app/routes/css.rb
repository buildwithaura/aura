class Main
  get '/css/*.css' do |fname|
    begin
      out = show :"css/#{fname}", :engine => [:sass, :scss, :less]
    rescue Errno::ENOENT => e
      pass
    end

    content_type :css
    out
  end
end
