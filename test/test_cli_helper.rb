module CliHelper
  # Capture stdout and stderr
  def capture(&blk)
    previous_stderr, $stderr = $stderr, StringIO.new
    previous_stdout, $stdout = $stdout, StringIO.new

    yield

    return [$stdout.string, $stderr.string]
  ensure
    $stderr = previous_stderr
    $stdout = previous_stdout
  end

  # Runs a CLI runner and captures output
  def cli(&blk)
    @stdout, @stderr = capture { yield }
  end

  def stdout
    @stdout
  end

  def stderr
    @stderr
  end

  # def aura(cmd)
  #   cli { Aura::CLI.run *cmd.split(' ') }
  # end
end
