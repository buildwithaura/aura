class Main
  get '/css/*.css' do |fname|
    out = show :"css/#{fname}", :engine => [:sass, :scss, :less] rescue pass

    content_type :css
    out
  end
end
