# frozen_string_literal: true

require "ht_sip_validator/validator/base"
require "set"

module HathiTrust::Validator
  # Validates that each filename appears only once in the SIP
  class Package::DuplicateFilenames < Base
    def perform_validation
      # converts the array of paths to a map from the base filename to
      # each path with that filename, then gives an error for each filename
      # that has multiple paths

      group_by_basename(@sip.paths)
        .reject { |_, paths| paths.length == 1 }
        .map do |filename, paths|
        create_error(
          validation_type: :file_absent,
          human_message: "Filename #{filename} appears multiple times "\
           " in the SIP: #{paths.join(", ")}. Each file name must appear "\
           " only once in the SIP.",
          extras: {filename: filename, actual: paths}
        )
      end
    end

    private

    def group_by_basename(paths)
      paths.map { |path| [File.basename(path), path] }
        .each_with_object(Hash.new { |h, k| h[k] = [] }) do |(filename, path), h|
        h[filename] << path
        h
      end
    end
  end
end
