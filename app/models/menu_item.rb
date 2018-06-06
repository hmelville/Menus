class MenuItem < ApplicationBase

  # Comment this out when you run rake db:seed - otherwise it throws a fit
  # @see https://github.com/collectiveidea/awesome_nested_set/wiki/Awesome-nested-set-cheat-sheet
  acts_as_nested_set

  validates_presence_of :name

  serialize :classes, Array

  # returns true if this menu item matches the supplied route.
  #
  # A Menu item matches a request if the path of the request corresponds with the url
  # of the menu item, or any of the menu item's descentants.
  def match_request?(path)
    self_and_descendants.to_a.any? {|mi| mi.url.present? && (path == mi.url || path.start_with?(mi.url+"/")) }
  end

  def self.permitted_attributes
    [:name, :url, :icon, :method, :parent_id, classes: []]
  end

  def self.to_hash
    roots.collect do |mi|
      mi.to_hash
    end
  end

  def to_hash
    result = { name: name,
                url: url,
                icon: icon,
                method: method,
                classes: classes }
    if children.any?
      result[:items] = children.collect {|mi| mi.to_hash }
    end
    return result
  end
end
