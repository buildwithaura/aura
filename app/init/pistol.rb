# Reloading
class Main
  unless production?
    FileUtils.mkdir_p Aura.root('tmp/')
    FileUtils.touch Aura.root('tmp/restart.txt')

    use(Pistol, app_files + [Aura.root('tmp/restart.txt')]) {
      reset! and load(ENV['APP_FILE'])
    }
  end
end
