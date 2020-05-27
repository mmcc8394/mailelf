class FormSelect < FormItem
  private

  def form_item(field, options)
    @form.select(field, options[:select_options], { include_blank: true }, { class: 'form-control' })
  end
end