class CollectionRecipe < ::ApplicationBase

  belongs_to :target, polymorphic: true
  belongs_to :recipe

  default_scope { joins(:recipe).order("recipes.name") }

  def name
    recipe.name
  end
end