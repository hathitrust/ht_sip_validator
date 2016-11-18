# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "set"

module HathiTrust::Validator

  # Validates that the only yml and md5 files present are meta.yml and
  # checksum.md5
  class Package::ExtraFiles < Base
    def perform_validation
      warn_extra_yml_files +
        warn_extra_md5_files
    end

    private

    def warn_extra_yml_files
      @sip.files.select {|f| File.extname(f) == ".yml" }
        .reject {|f| f == "meta.yml" }
        .map do |filename|
        create_warning(
          validation_type: :file_absent,
          human_message: "Unexpected YAML file #{filename}. "\
          "Only meta.yml will be used.",
          extras: { filename: filename }
        )
      end
    end

    def warn_extra_md5_files
      @sip.files.select {|f| File.extname(f) == ".md5" }
        .reject {|f| f == "checksum.md5" }
        .map do |filename|
        create_warning(
          validation_type: :file_absent,
          human_message: "Unexpected MD5 file #{filename}. "\
          "Only checksum.md5 will be used.",
          extras: { filename: filename }
        )
      end
    end

  end
end
