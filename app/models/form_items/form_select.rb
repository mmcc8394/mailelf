class FormSelect < FormItem
  private

  def form_item(field, options)
    @form.select(field, options.delete(:select_items), options, class: 'form-control')
  end
end