class FormTextField < FormItem
  private

  def form_item(field, options)
    @form.text_field(field, class: 'form-control', placeholder: options[:placeholder])
  end
end