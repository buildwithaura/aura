module TempHelper
  def in_temp_dir(&blk)
    dir = File.join(Dir.tmpdir, "cli-#{rand}")
    FileUtils.mkdir_p(dir)
    Dir.chdir(dir) { yield dir }
  ensure
    FileUtils.rm_rf(dir)
  end
end
