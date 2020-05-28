class FormTextArea < FormItem
  private

  def form_item(field, options)
    @form.text_area(field, class: 'form-control', placeholder: options[:placeholder], rows: options[:rows])
  end
end