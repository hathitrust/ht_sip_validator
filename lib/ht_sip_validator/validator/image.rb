# frozen_string_literal: true

module HathiTrust::Validator::Image
  # Filename extensions to recognize as images
  IMG_FILE_EXTENSIONS = [".jp2", ".tif"].freeze

  # @param filenames [Array] filenames with extension
  # @return [Array] sub-set of filenames recognized as images
  def self.image_files(filenames = [])
    filenames.select {|filename| IMG_FILE_EXTENSIONS.include? File.extname(filename).downcase }.sort
  end
end

require "ht_sip_validator/validator/image/filenames"
require "ht_sip_validator/validator/image/sequence"
require "ht_sip_validator/validator/image/count"
