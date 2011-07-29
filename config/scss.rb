class Main
  set :scss, {
    :load_paths => [
      Aura.gem_root('app/css'),
      Dir[Aura.gem_root('extensions/*/css')],
      Dir[Aura.root('extensions/*/css')],
      Aura.root('app/css')
    ].flatten
  }
  set :scss, self.scss.merge(:line_numbers => true, :debug_info => true, :always_check => true) if self.development?
  set :scss, self.scss.merge(:style => :compressed) if self.production?

  set :sass, scss
end
