class Aura::Models::Page
  subtype :portfolio,
    :name     => "Portfolio page",
    :template => "id_portfolio"

  custom_field :excerpt

  form :portfolio do
    text :excerpt, "Portfolio excerpt"

    #fieldset :extra do
    #  text :'custom.excerpt', "Excerpt"
    #end
  end
end
