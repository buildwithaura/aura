module Terra
  PREFIX = File.dirname(__FILE__)
  autoload :Field,    "#{PREFIX}/terra/field"
  autoload :Fields,   "#{PREFIX}/terra/fields"
  autoload :Fieldset, "#{PREFIX}/terra/fieldset"
  autoload :Form,     "#{PREFIX}/terra/form"
end

