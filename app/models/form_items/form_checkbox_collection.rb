class FormCheckboxCollection < FormItem
  private

  def form_item(field, options)
    '<span class="option">' +
      @form.collection_check_boxes(field, options[:collection], options[:value_function], options[:label_function]) +
      '</span>'
  end
end