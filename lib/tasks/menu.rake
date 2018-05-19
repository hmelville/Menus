require "json"

namespace :menu do
  desc "Setup menu structure data"
  task setup: :environment do
    MenuItem.destroy_all

    menu_file = File.read("lib/tasks/menu.json")
    menu_data = JSON.parse(menu_file)

    menu_data.each do |item|
      create_menu_item(item)
    end
  end

  def create_menu_item(data, parent=nil)
    menu_item = MenuItem.create(name: data["name"], url: data["url"], parent_id: parent.try(:id))
    if data["items"].present?
      data["items"].each do |item|
        create_menu_item(item, menu_item)
      end
    end
  end
end