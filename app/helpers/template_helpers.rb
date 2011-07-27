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

    # Template helper: partial (Helpers)
    # Renders a partial.
    #
    def partial(template, locals={}, options={})
      layout, @layout = @layout, nil
      out = show template, {:layout => false}.merge(options), locals
      @layout = layout
      out
    end

    # Template helper: has_content? (Helpers)
    # Checks if a given content block is defined.
    #
    def has_content?(key)
      return false  unless content_blocks.keys.include?(key.to_sym)
      content_blocks[key.to_sym].any?
    end

    # Template helper: content_for! (Helpers)
    # Like content_for, but overwrites any blocks.
    #
    def content_for!(key, &blk)
      content_blocks[key.to_sym] = Array.new
      content_for key, &blk
    end

    # Template helper: content_for? (Helpers)
    # Synonym of has_content?
    #
    def content_for?(key)
      (content_blocks[key.to_sym] || Array.new).any?
    end

    # Template helper: yield_content_of (Helpers)
    # Loads a given template and yields a certain content block of it.
    #
    # ##  Usage
    #     yield_content_of(template, section[, locals])
    #
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
