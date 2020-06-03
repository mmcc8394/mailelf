class FormFileUpload < FormItem
  private

  def form_item(field, options)
    @form.file_field(field, options.merge({ class: 'form-control-file' }))
  end
end