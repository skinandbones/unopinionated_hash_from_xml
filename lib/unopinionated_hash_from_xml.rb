module ActiveSupport
  module CoreExtensions
    module Hash
      module Conversions
        module ClassMethods

          def from_xml(xml, options = {})
            if options[:unrename_keys] == false
              typecast_xml_value(XmlMini.parse(xml))
            else
              typecast_xml_value(unrename_keys(XmlMini.parse(xml)))
            end
          end

        end
      end
    end
  end
end