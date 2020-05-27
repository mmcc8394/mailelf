class FormSubmit < FormItem
  private

  def label_tag(field)
    ''
  end

  def form_item(field, options)
    @form.submit(options[:submit_text], class: 'btn btn-primary')
  end
end