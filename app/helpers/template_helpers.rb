class Main
  module TemplateHelpers
    # Makes a template extend upon another template.
    #
    # Example:
    #
    #   -# Should be the first line.
    #   != extends :'base/edit', options
    #
    #   - content_for! :body do
    #     This will override the body of the base/edit template
    #
    def extends(name, locals={})
      partial name, locals
    end

    def partial(template, locals={})
      layout, @layout = @layout, nil
      out = show template, {:layout => false}, locals
      @layout = layout
      out
    end

    def content_for!(key, &blk)
      content_blocks[key.to_sym] = Array.new
      content_for key, &blk
    end

    def content_for?(key)
      (content_blocks[key.to_sym] || Array.new).any?
    end

    # Loads a given template and yields a certain content block of it.
    def yield_content_of(template, section, locals={})
      custom_activate!

      show template, { :layout => false }, locals
      ret = yield_content(section)

      custom_deactivate!
      ret
    end

  protected
    def custom_activate!
      @old_content_blocks ||= Array.new
      @old_content_blocks << @content_blocks
      @content_blocks = Hash.new { |h, k| h[k] = [] }
    end

    def custom_deactivate!
      @content_blocks = @old_content_blocks.pop
    end
  end

  helpers TemplateHelpers
end
