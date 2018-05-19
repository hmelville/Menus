class MenuItem < ActiveRecord::Base
  acts_as_nested_set

  validates_presence_of :name

  def match_request?(path)
    self_and_descendants.to_a.any? {|mi| mi.url.present? && (path == mi.url || path.start_with?(mi.url+"/")) }
  end

  def self.permitted_attributes
    [:name, :url, :parent_id []]
  end

  def self.to_hash
    roots.collect do |mi|
      mi.to_hash
    end
  end

  def to_hash
    result = { name: name, url: url }
    if children.any?
      result[:items] = children.collect {|mi| mi.to_hash }
    end
    return result
  end
end