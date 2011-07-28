require File.expand_path('../../test_helper', __FILE__)
require 'aura/cli'

class CLITest < Test::Unit::TestCase
  BIN_ROOT = File.expand_path('../../../bin', __FILE__)

  test "aura new (success)" do
    in_temp_dir { |dir|
      aura "new x"

      assert File.directory?('x/')
      assert File.file?('x/Gemfile')
      assert File.file?('x/config.ru')

      aura "new x"
      assert stderr.include?("already exists")
    }
  end

  test "aura -v" do
    aura "-v"
    assert stderr.empty?
    assert stdout.include?(Aura.version)
  end

  test "aura --version" do
    aura "--version"
    assert stderr.empty?
    assert stdout.include?(Aura.version)
  end

  test "aura" do
    aura ""
    assert stderr.include?("Usage: aura_ <command>")
    assert stderr.include?("new")
    assert stderr.include?(Aura::CLI.task(:new).description)
  end
end
