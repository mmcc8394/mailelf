class FormPassword < FormItem
  private

  def form_item(field, options)
    @form.password_field(field, class: 'form-control', placeholder: options[:placeholder])
  end
end