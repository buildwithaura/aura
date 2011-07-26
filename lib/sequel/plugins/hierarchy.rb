# Sequel plugin: AuraHierarchy
# Used on models that have children and parents.
#
# ## Description
#    This automatically gives models parent/child support.
#
# #### How to use
# Use `plugin :aura_hierarchy`.
#
#     module Aura::Models
#       class Book < Model
#         plugin :aura_hierarchy
#       end
#     end
#
# #### Example
# Our `Book` class can now have parents and children.
#
#     book = Book[2]
#
#     # Traversion
#     book.parent
#     book.children
#     book.siblings
#
module Sequel::Plugins::AuraHierarchy
  def self.configure(model, options={})
    model.many_to_one :parent, :class => model
    model.one_to_many :children, :key => :parent_id, :class => model
  end

  module InstanceMethods
    def parentable?
      true
    end

    def siblings
      if parent.nil?
        self.class.filter(:parent_id => nil)
      else
        parent.children
      end
    end

    def prev_sibling
      siblings.each_cons(2) { |(other, item)| return item  if other.id == self.id }
    end

    def next_sibling
      siblings.each_cons(2) { |(item, other)| return item  if other.id == self.id }
    end

    def nearest
      children.any? ? children : siblings
    end

    def nearest_parent
      children.any? ? self : parent
    end

    def crumbs
      return [self]  if parent.nil?
      parent.crumbs + [self]
    end
  end

  module ClassMethods
    def parentable?
      true
    end

    def roots
      filter(:parent_id => nil)
    end
  end
end
