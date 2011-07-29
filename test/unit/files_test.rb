require File.expand_path('../../test_helper', __FILE__)

class FilesTest < Test::Unit::TestCase
  test "[]" do
    path = Aura.files['damogram.txt']
    assert path.is_a?(String)
    assert_equal "Beedlebrox!", File.read(path).strip
  end

  test "glob" do
    paths = Aura.files.glob('d*')
    assert_equal [ Aura.files['damogram.txt'] ], paths
  end
end
