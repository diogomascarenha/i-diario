class Select2Input < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] = "hidden"
    input_html_options[:style] = "width: 100%;" + (input_html_options[:style] || "")
    input_html_options[:data] = (input_html_options[:data] || {}).merge({ elements: parse_collection })
    input_html_options[:data] = (input_html_options[:data] || {}).merge({ multiple: fetch_multiple })

    @builder.text_field(attribute_name, input_html_options)
  end

  private

  def fetch_multiple
    options.fetch :multiple, false
  end

  def parse_collection
    return options[:elements] if options[:elements].is_a? String

    options[:elements].map { |g| { id: g.id, name: g.to_s, text: g.to_s } }.to_json
  end
end
