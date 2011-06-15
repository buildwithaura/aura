class Main
  configure :development do
    get '/design_tests' do
      spec = Main.root_path('{core,extensions}', '*', 'views', 'design_tests', '*')
      names = Dir[spec].map { |f| File.basename(f).gsub(/\.[^\.]*$/, '') }
      names.map do |name|
        "<li><a href='/design_test/#{name}'>#{name}</a></li>"
      end
    end

    get '/design_test/:test' do |test|
      show :"design_tests/#{test}"
    end
  end
end
