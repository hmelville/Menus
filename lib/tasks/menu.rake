require "json"

namespace :menu do
  desc "Setup menu structure data"
  task :setup => :environment do
    MenuItem.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE menu_items")

    menu_file = File.read("lib/tasks/menu.json")
    menu_data = JSON.parse(menu_file)

    menu_data.each do |item|
      create_menu_item(item)
    end
  end

  def create_menu_item(data, parent=nil)
    puts data
    menu_item = MenuItem.create(name: data["name"], url: data["url"], icon: data["icon"], method: data["method"], classes: data["classes"], parent_id: parent.try(:id))
    if data["items"].present?
      data["items"].each do |item|
        create_menu_item(item, menu_item)
      end
    end

    # if data["name"] == "New Account"
    #   Budgets::Account.all.each do |account|
    #     acc_data =
    #     {
    #       "name" => account.name,
    #       "url" => "/budgets/accounts/#{account.id}",
    #       "icon" => "calculator",
    #       "method" => "",
    #       "classes" => [],
    #       "user_id" => account.user_id
    #     }
    #     create_menu_item(acc_data, menu_item)
    #   end
    # end
  end
end