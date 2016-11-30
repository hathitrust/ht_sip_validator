# frozen_string_literal: true

module HathiTrust::Validator

  # Interface of per-file validators
  class FileValidator < Base

    def validate_file(filename, filehandle)
      [perform_file_validation(filename, filehandle)].flatten.compact
    end

    # Actual work of performing the validation
    # @return [Array<Message>|Message|nil]
    def perform_file_validation(_filename, _filehandle)
      raise NotImplementedError
    end

  end

end
