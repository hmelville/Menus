require 'time'
require 'csv'

class Import

  def self.import_ingredients(user_id, file_name)
    file_data = self.get_data_from_file(file_name, ",")
    output_file = file_name.sub(".csv", "_output.csv")

    user = User.find_by_id(user_id)

    user.menu_rotations.destroy_all
    user.meals.destroy_all
    user.recipes.destroy_all
    user.ingredients.destroy_all
    user.shopping_lists.destroy_all

    headings = %w(recipe ingredient qty unit new_id)
    CSV.open(output_file, "w", headers: headings, write_headers: true) do |csv|
      file_data.each do |row|
        row_data = []
        recipe_name = row[:recipe]
        ingredient_name = row[:ingredient]
        qty = row[:qty]
        unit_abbreviation = row[:unit]

        row_data << recipe_name
        row_data << ingredient_name
        row_data << qty
        row_data << unit_abbreviation

        recipe = user.recipes.find_by(name: recipe_name) || Recipe.create(name: recipe_name, user: user)

        ingredient = user.ingredients.find_by(name: ingredient_name) || Ingredient.create(name: ingredient_name, user: user)

        unit = Unit.find_by(abbreviation: unit_abbreviation)

        raise "Unit #{unit_abbreviation} not found!" unless unit.present?

        row_data << CollectionIngredient.create(collection_id: recipe.collection.id,ingredient_id: ingredient.id, quantity: qty, unit_id: unit.id).id

        csv << row_data
      end
    end
    puts output_file
    puts nil
  end

  def self.get_data_from_file(file_name, delimiter, required_headers = nil)
    data = []

    csv_options = {col_sep: delimiter, headers: :first_row, header_converters: :symbol}

    unless required_headers.blank?
        actual_columns = CSV.open(file_name, csv_options, &:readline).headers
        unless (missing_columns = (required_headers - actual_columns)).empty?
            fail "The following required columns are missing from #{file_name}: #{missing_columns.to_sentence}"
        end
    end

    CSV.foreach(file_name, csv_options) do |row|
        data << row.to_hash
    end

    return data
  end
end