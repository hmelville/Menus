require 'time'
require 'csv'

module FoodMenus

  class Import

    def self.import_units(file_name)
      file_data = self.get_data_from_file(file_name, ",")
      output_file = file_name.sub(".csv", "_output.csv")

      FoodMenus::Unit.destroy_all

      headings = %w(Name Abbreviation Kind ConversionRate new_id)
      CSV.open(output_file, "w", headers: headings, write_headers: true) do |csv|
        file_data.each do |row|
          row_data = []

          name = row[:name]
          abbreviation = row[:abbreviation]
          kind = row[:kind]
          conversion_rate = row[:conversion_rate]

          row_data << name
          row_data << abbreviation
          row_data << kind
          row_data << conversion_rate

          row_data << FoodMenus::Unit.create(name: name, abbreviation: abbreviation, kind: kind, conversion_rate: conversion_rate).id

          csv << row_data
        end
      end
      puts output_file
      puts nil
    end

    def self.import_ingredients(file_name)
      file_data = self.get_data_from_file(file_name, ",")
      output_file = file_name.sub(".csv", "_output.csv")


      FoodMenus::MenuRotation.destroy_all
      FoodMenus::Meal.destroy_all
      FoodMenus::Recipe.destroy_all
      FoodMenus::Ingredient.destroy_all
      FoodMenus::ShoppingList.destroy_all

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

          recipe = FoodMenus::Recipe.find_by(name: recipe_name) || FoodMenus::Recipe.create(name: recipe_name)

          ingredient = FoodMenus::Ingredient.find_by(name: ingredient_name) || FoodMenus::Ingredient.create(name: ingredient_name)

          unit = FoodMenus::Unit.find_by(abbreviation: unit_abbreviation)

          raise "Unit #{unit_abbreviation} not found!" unless unit.present?

          # unless recipe.collection.collection_ingredients.present? && recipe.collection.collection_ingredients.where(ingredient_id: ingredient.id).any?
            # recipe.collection.collection_ingredients.create(ingredient_id: ingredient.id, quantity: qty, unit_id: unit.id)
          row_data << FoodMenus::CollectionIngredient.create(collection_id: recipe.collection.id,ingredient_id: ingredient.id, quantity: qty, unit_id: unit.id).id
          # end

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
end