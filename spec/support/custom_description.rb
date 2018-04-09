# frozen_string_literal: true
# Adds a :custom_description option to the top-level block of the RSpec test.
# This enables the class or module name to be independent of its documentation.
# @example
#
#   RSpec.describe FooController, custom_description: "The Foo controller" do
#     it "does some stuff" do
#       ...
#
# Results in output:
#
#   The Foo controller
#     does some stuff

module CustomDescription
  def example_group_started(notification)
    output.puts if @group_level == 0

    if notification.group.metadata.key?(:custom_description) && @group_level == 0
      output.puts "#{current_indentation}#{notification.group.metadata[:custom_description].strip}"
    else
      output.puts "#{current_indentation}#{notification.group.description.strip}"
    end

    @group_level += 1
  end
end

RSpec::Core::Formatters::DocumentationFormatter.prepend CustomDescription
