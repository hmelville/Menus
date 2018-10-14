module ApplicationHelper
  def top_menu
    render partial: '/shared/menu', locals: { menus: MenuItem }
  end

  def menu_item_classes(menu_item, menu_items)
    result = []
    result << 'active' if menu_item_active_state?(menu_item, menu_items)
    result << 'not-click' unless menu_item.url.present?
    result << 'has-dropdown' unless menu_item.url.present?
    result += menu_item.classes.split(',') if menu_item.classes.present?
    return result.join(" ")
  end

  def menu_item_url(menu_item)
    menu_item.url.present? ? menu_item.url : "#"
  end

  def menu_item_active_state?(menu_item, menu_items)
    if menu_item.name == "Budgets" && request.path.start_with?("/budgets")
      true
    elsif menu_item.url.present?
      request.path == menu_item.url || request.path.start_with?(menu_item.url+"/")
    else
      menu_item_parents(menu_items.select {|mi| mi.url.present? && (mi.url == request.path || request.path.start_with?(mi.url+"/"))}.first, menu_items).include?(menu_item.id)
    end
  end

  def menu_item_parents(menu_item, menu_items, ids=[])
    if menu_item.present?
      ids << menu_item.id
      menu_item_parents(menu_items.select {|mi| mi.id == menu_item.parent_id}.first, menu_items, ids)
    else
      return ids
    end
  end

  def main_menu(menu_items, &block)
    menu_items = menu_items.order(:lft) if menu_items.is_a? Class
    return '' unless menu_items.any?

    output = '<ul class="left"><li class="' + menu_item_classes(menu_items.first, menu_items) + '">'
    path = [nil]

    menu_items.each_with_index do |menu_item, index|

      if menu_item.name == "New Account"
        # byebug
      end

      if menu_item.parent_id != path.last
        if path.include?(menu_item.parent_id)
          while path.last != menu_item.parent_id
            path.pop
            output << '</li></ul>'
          end
          output << '</li><li class="' + menu_item_classes(menu_item, menu_items) + '">'
        else
          path << menu_item.parent_id
          output << '<ul class="dropdown">'

          if menu_item.name == "New Account"
            group = ""
            current_user.accounts.each do |account|
              if group != account.group
                group = account.group
                output << '</li><li class="divider"><a href="#">' + account.group + '</a>'
              end

              account_item = MenuItem.new(name: account.name, url:"/budgets/accounts/#{account.id}", icon: "university", method: "", classes: [], parent_id: menu_item.parent_id)
              output << '</li><li class="' + menu_item_classes(account_item, menu_items) + '" style="width: 200px;">'
              output << '<a href="' + menu_item_url(account_item) + '">' + get_icon(account_item) + capture(account_item, path.size - 1, &block) + '<div style="float:right;">' + number_to_currency(account.current_balance, precision: 2, format: "%u%n", unit: account.currency) + '</div></a>'

            end
          end

          output << '<li class="' + menu_item_classes(menu_item, menu_items) + '">'
        end
      elsif index != 0
        output << '</li><li class="' + menu_item_classes(menu_item, menu_items) + '">'
      end

      output << '<a href="' + menu_item_url(menu_item) + '"' + get_method(menu_item) +'>' + get_icon(menu_item) + capture(menu_item, path.size - 1, &block) + '</a>'
    end

    output << '</li></ul>' * path.length
    output.html_safe
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
end
