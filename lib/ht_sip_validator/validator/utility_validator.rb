# frozen_string_literal: true

module HathiTrust::Validator

  # Interface of per-file validators where rather than validating the file
  # directly we are validating based on the XML output from some tool
  class UtilityValidator < Base

    def validate_file_xml(filename, xml)
      if should_validate?(filename)
        [perform_file_validation(filename, xml)].flatten.compact
      else
        []
      end
    end

    # Actual work of performing the validation
    # @return [Array<Message>|Message|nil]
    def perform_file_validation(_filename, _filehandle)
      raise NotImplementedError
    end

    # Checks whether the validator should run on the given file
    def should_validate?(_filename)
      raise NotImplementedError
    end

  end

end
