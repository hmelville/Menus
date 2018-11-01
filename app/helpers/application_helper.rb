module ApplicationHelper
  def main_menu(&block)
    output = '<ul class="left">'
    MenuItem.where(parent: nil).order(:lft).each do |root_item|
      next if root_item.name == "Menus" && !current_user.use_menus
      next if root_item.name == "Budgets" && !current_user.use_budgets
      add_item(root_item, output, &block)
    end
    output << '</ul>'
    output.html_safe
  end

  def add_item(menu_item, output, &block)
    output << '<li class="' + menu_item_classes(menu_item) + '">'

    if menu_item.name == "Menus"
      # byebug
    end

    output << '<a href="' + menu_item_url(menu_item) + '"' + get_method(menu_item) +'>' + get_icon(menu_item) + menu_item.name + '</a>'

    if menu_item.children.any?
      output << '<ul class="dropdown">'

      if menu_item.name == "Budgets"
        current_user.accounts.group_by(&:group).each do |group|
          output << '<li class="divider"><a href="#">' + group[0] + '</a></li>'
          group[1].each do |account|
            account_item = MenuItem.new(name: account.name, url: "/budgets/accounts/#{account.id}", icon: "university", method: "", classes: [], parent_id: menu_item.parent_id)
            output << '<li class="' + menu_item_classes(account_item) + '" style="width: 200px;">'
            output << '<a href="' + menu_item_url(account_item) + '">' + get_icon(account_item) + account.name + '<div style="float:right;">' + number_to_currency(account.current_balance, precision: 2, format: "%u%n", unit: account.currency) + '</div></a>'
            output << '</li>'
          end
        end
      end

      menu_item.children.each do |child|
        add_item(child, output, &block)
      end
      output << '</ul>'
    end

    output << '</li>'
  end

  def menu_item_classes(menu_item)
    result = []
    result << 'active' if menu_item_active_state?(menu_item)
    result << 'not-click' unless menu_item.url.present?
    result << 'has-dropdown' unless menu_item.url.present?
    result += menu_item.classes.split(',') if menu_item.classes.present?
    return result.join(" ")
  end

  def menu_item_url(menu_item)
    menu_item.url.present? ? menu_item.url : "#"
  end

  def menu_item_active_state?(menu_item)

    if menu_item.name == "Menus"
      # byebug
    end

    if menu_item.name == "Budgets" && request.path.start_with?("/budgets")
      true
    elsif menu_item.url.present?
      request.path == menu_item.url || request.path.start_with?(menu_item.url + "/")
    else
      menu_item.self_and_descendants.collect(&:url).include?(request.path)
    end
  end

  def get_method(menu_item)
    unless menu_item.method.blank?
      return ' data-method="' + menu_item.method + '"'
    end
    return ''
  end

  def get_icon(menu_item)
    unless menu_item.icon.blank?
      return icon(menu_item.icon,'')
    end
    return ''
  end

  def partial_class(partial)
    partial.split(".").first.split("/").last.sub(/^_/, "")
  end
end
