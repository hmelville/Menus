module ApplicationHelper
  def top_menu
    render partial: '/shared/menu', locals: { menus: MenuItem }
  end

  def menu_item_classes(menu_item, menu)
    result = []
    result << 'active' if menu_item_active_state?(menu_item, menu)
    result << 'not-click' unless menu_item.url.present?
    result << 'has-dropdown' unless menu_item.url.present?
    return result.join(" ")
  end

  def menu_item_url(menu_item)
    menu_item.url.present? ? menu_item.url : "#"
  end

  def menu_item_active_state?(menu_item, menu)
    if menu_item.url.present?
      request.path == menu_item.url || request.path.start_with?(menu_item.url+"/")
    else
      menu_item_parents(menu.select {|mi| mi.url.present? && (mi.url == request.path || request.path.start_with?(mi.url+"/"))}.first, menu).include?(menu_item.id)
    end
  end

  def menu_item_parents(menu_item, menu, ids=[])
    if menu_item.present?
      ids << menu_item.id
      menu_item_parents(menu.select {|mi| mi.id == menu_item.parent_id}.first, menu, ids)
    else
      return ids
    end
  end

  def main_menu(objects, &block)
    objects = objects.order(:lft) if objects.is_a? Class
    return '' unless objects.any?

    output = '<ul class="left"><li class="' + menu_item_classes(objects.first, objects) + '">'
    path = [nil]

    objects.each_with_index do |object, index|
      if object.parent_id != path.last
        if path.include?(object.parent_id)
          while path.last != object.parent_id
            path.pop
            output << '</li></ul>'
          end
          output << '</li><li class="' + menu_item_classes(object, objects) + '">'
        else
          path << object.parent_id
          output << '<ul class="dropdown"><li class="' + menu_item_classes(object, objects) + '">'
        end
      elsif index != 0
        output << '</li><li class="' + menu_item_classes(object, objects) + '">'
      end
      output << '<a href="' + menu_item_url(object) + '">' + capture(object, path.size - 1, &block) + '</a>'
    end

    output << '</li></ul>' * path.length
    output.html_safe
  end
end
