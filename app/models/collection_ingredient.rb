class CollectionIngredient < ::ApplicationBase

  belongs_to :target, polymorphic: true
  belongs_to :ingredient
  belongs_to :unit

  validates_presence_of :ingredient_id, :target_id, :quantity, :unit_id

  default_scope { joins(:ingredient).where(deleted_at: nil).order("ingredients.name") }

  scope :with_deleted, -> { unscope(:where).where.not(deleted_at: nil) }

  def to_s
    "#{ingredient.name} (#{quantity}#{unit.try(:abbreviation)})"
  end

  def name
    ingredient.name
  end
end