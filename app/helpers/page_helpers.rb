class Main
  module PageHelpers
    def body_class(v = nil)
      @body_classes ||= []
      @body_classes << v  if v

      @body_classes.join(' ')
    end

    def title(title=nil)
      @page_title = title  if title
      @page_title
    end

    def has_content?(key)
      return false  unless content_blocks.keys.include?(key.to_sym)
      content_blocks[key.to_sym].any?
    end

    def link_to(url, *a, &b)
      attrs = Hash.new
      attrs[:href]  = url

      attrs[:class] = 'active'  if request.fullpath == url

      attrs = attr_merge(attrs, a.shift)  if a.first.is_a?(Hash)

      content = ''
      if block_given?
        content = capture_haml(&b)
      elsif a.first.is_a?(String)
        content = a.shift
      elsif a.first.is_a?(Proc)
        content = a.shift.call
      else
        content = a.shift.to_s
      end

      raw_tag(:a, content, attrs)
    end

  protected
    def attr_merge(ret, other)
      if ret.keys.include?(:class) and other.keys.include?(:class)
        ret[:class] += " " + other.delete(:class)
      end

      ret.merge(other)
      ret
    end

    def raw_tag(tag, content, atts = {})
      if self_closing?(tag)
        %(<#{ tag }#{ tag_attributes(atts) } />)
      else
        %(<#{ tag }#{ tag_attributes(atts) }>#{content}</#{ tag }>)
      end
    end

    def tag(tag, content, atts = {})
      if self_closing?(tag)
        %(<#{ tag }#{ tag_attributes(atts) } />)
      else
        %(<#{ tag }#{ tag_attributes(atts) }>#{h content}</#{ tag }>)
      end
    end

    def tag_attributes(atts = {})
      atts.inject([]) { |a, (k, v)| 
        a << (' %s="%s"' % [k, escape_attr(v)]) if v
        a
      }.join('')
    end

    def escape_attr(str)
      str.to_s.gsub("'", "&#39;").gsub('"', "&quot;")
    end

    def self_closing?(tag)
      @self_closing ||= [:area, :base, :basefont, :br, :hr,
                         :input, :img, :link, :meta]

      @self_closing.include?(tag.to_sym)
    end
  end

  helpers PageHelpers
end
