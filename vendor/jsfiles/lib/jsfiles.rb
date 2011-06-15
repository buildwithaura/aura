# A list of JavaScript files.
#
# This is a general-purpose class usually used for minification
# of JS assets.
#
# === Usage example
#
#   files  = Dir['public/js/jquery.*.js']
#   files += Dir['public/js/app.*.js']
#   Main.set :js_files, JsFiles.new(files, :prefix => '/javascript')
#
#   Main.js_files.mtime #=> (Time) 2010-09-02 8:00PM
#
#   # For, say, a Rake task
#   File.open('public/scripts.js', 'w') do |f|
#     f << Main.js_files.combined
#   end
#
#   File.open('public/scripts.min.js', 'w') do |f|
#     f << Main.js_files.compressed
#   end
#
class JsFiles
  attr_accessor :files

  # Creates a JsFiles object based on the list of given files.
  #
  # @param files [Array] A list of string file paths.
  # @example
  #
  #   files  = Dir['public/js/jquery.*.js']
  #   $js_files = JsFiles.new(files)
  #
  def initialize(files, options={})
    @files, @options = files, options
    @options[:prefix] ||= '/js/'
  end

  # @group Metadata methods
  
  # Returns the the modified time of the entire package.
  #
  # @return [Time] The last modified time of the most recent file.
  #
  def mtime
    @files.map { |f| File.mtime(f) }.max
  end

  # Returns a list of the URLs for the package.
  #
  # @example
  #
  #   -# This is the same as calling #to_html.
  #   - Main.js_files.hrefs.each do |href|
  #     %script{:src => href}
  #
  def hrefs
    @files.map { |f| @options[:prefix] + File.basename(f) }
  end

  # Returns the <script> tags for the development version.
  #
  # @example
  # 
  #   - if settings.production?
  #     %script{:src => '/js/min.js'}
  #   - else
  #     != Main.js_files.to_html
  #
  def to_html
    hrefs.map { |href| "<script type='text/javascript' src='#{href}'></script>" }.join("\n")
  end

  # @group Output methods

  # Returns the combined source of all the files.
  def combined
    @combined ||= @files.map { |file| File.open(file) { |f| f.read } }.join("\n")
  end

  # Returns a combined, minifed source of all the files.
  def compressed
    require 'jsmin'
    @compressed ||= JSMin.minify(combined).strip
  end
end

