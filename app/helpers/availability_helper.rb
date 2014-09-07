module AvailabilityHelper
  def options_for_selected_service(collection)
    debugger
    options = collection.map do |element|
      [element.name, element.value]
      # [element.send(text_method), element.send(value_method), attr_name => element.send(attr_field)]
    end
    # corresponding_staff = get_related_staff(service_id)
  end

end
