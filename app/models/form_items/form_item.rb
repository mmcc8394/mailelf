class FormItem
  def initialize(form)
    @form = form
  end

  def build_form_item(field, options = {})
    str = start_form_group
    str += label_tag(field)
    str += form_item(field, options)
    (str + end_form_group).html_safe
  end

  def text_field(field, placeholder)
    FormTextField.new(@form).build_form_item(field, { placeholder: placeholder })
  end

  def password(field, placeholder)
    FormPassword.new(@form).build_form_item(field, { placeholder: placeholder })
  end

  def select(field, select_options)
    FormSelect.new(@form).build_form_item(field, { select_options: select_options })
  end

  def checkbox_collection(field, collection, value_function, label_function)
    FormCheckboxCollection.new(@form).build_form_item(field, { collection: collection,
                                                               value_function: value_function,
                                                               label_function: label_function })
  end

  def submit(text)
    FormSubmit.new(@form).build_form_item(nil, { submit_text: text })
  end

  def submit_with_cancel(text)
    FormSubmitWithCancel.new(@form).build_form_item(nil, { submit_text: text })
  end

  private

  def start_form_group
    '<div class="form-group">'
  end

  def label_tag(field)
    @form.label(field, class: 'sr-only')
  end

  def form_item(field, options)
    'not implemented yet'
  end

  def end_form_group
    '</div>'
  end
end