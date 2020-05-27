class FormSubmitWithCancel < FormItem
  private

  def label_tag(field)
    ''
  end

  def form_item(field, options)
    @form.submit(options[:submit_text], class: 'btn btn-primary') +
        '<a href="#" onclick="history.back();" class="submit-cancel">cancel</a>'.html_safe
  end
end