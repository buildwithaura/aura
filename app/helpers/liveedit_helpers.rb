class Main
  module LiveEditHelpers
    # ##  Example
    #     %h1{live_editable(@page, :title)}
    #       = @page.title
    #
    def live_editable(object, field)
      return Hash.new  unless logged_in?

      @live_editable = true

      { :'data-live_editable'       => true,
        :'data-live_editable_type'  => object.class,
        :'data-live_editable_id'    => object.id,
        :'data-live_editable_field' => field,
        :'data-live_editable_src'   => object.send(field)
      }
    end
  end

  helpers LiveEditHelpers
end
