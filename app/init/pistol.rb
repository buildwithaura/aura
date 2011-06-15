# Reloading
class Main
  unless production?
    FileUtils.mkdir_p approot('tmp/')
    FileUtils.touch approot('tmp/restart.txt')

    use(Pistol, app_files + [approot('tmp/restart.txt')]) {
      reset! and load($0)
    }
  end
end
