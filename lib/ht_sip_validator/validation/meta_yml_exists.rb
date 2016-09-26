module HathiTrust
  module Validation

    # validates that package contains meta.yml
    class MetaYmlExists < Validation::Base
      def validate
        unless @sip.files.include?('meta.yml')
          @messages << Message.new(
            validator: self.class,
            validation: :exists,
            level: Message::ERROR,
            human_message: 'SIP is missing meta.yml',
            extras: {filename: 'meta.yml'}
          )
        end
        @messages
      end
    end
  end
end
