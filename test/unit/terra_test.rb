require File.expand_path('../../test_helper', __FILE__)
require 'terra'

class TerraTest < Test::Unit::TestCase
  setup do
    @form = Terra::Form.new
  end

  test "default fieldsets" do
    @form.configure {
      text :hi, "Hi"
    }

    assert @form.fieldset(:default).name == "Default"
    assert @form.fieldsets == [@form.fieldset(:default)]
  end

  test "fieldset default name" do
    @form.configure {
      fieldset :meta do
        text :hi, "Hi"
      end
    }

    assert @form.fieldset(:meta).name == "Meta"
  end

  test "fieldset name" do
    @form.configure {
      fieldset :meta, "Metadata" do
        text :hi, "Hi"
      end
    }

    assert @form.fieldset(:meta).name == "Metadata"
  end

  test "field lookup" do
    @form.configure {
      text :hi
    }

    assert @form.field(:hi) == @form.fieldset(:default).field(:hi)
  end

  test "field deep lookup" do
    @form.configure {
      fieldset :one do
        text :name
      end
      fieldset :two do
        text :email
      end
    }

    assert @form.field(:name) == @form.fieldset(:one).field(:name)
    assert @form.field(:email) == @form.fieldset(:two).field(:email)
  end

  test "many ways to define select options" do
    forms = [
      Terra::Form.new.configure {
        options :category, "Categories", :options =>
          [ { :a => "Apple" },
            { :b => "Banana" }
          ].to_hash_array
      },

      Terra::Form.new.configure {
        options :category, "Categories", :options =>
          { :a => "Apple", :b => "Banana" }
      },

      Terra::Form.new.configure {
        options :category, "Categories", :options =>
          lambda { |x|
            [ { :a => "Apple" },
              { :b => "Banana" }
            ].to_hash_array
          }
      }
    ]

    forms.each do |form|
      output = form.field(:category).to_html('a')
      assert output.include?("<select id='field_category' name='editor[category]'>\n<option value='a' selected='selected'>a</option>\n<option value='b'>b</option>\n</select>")

      assert form.fieldset(:default).field(:category)
    end
  end
end
