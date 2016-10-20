# frozen_string_literal: true

module HathiTrust::Validation::Image
  class Filenames < HathiTrust::Validation::Base


    def perform_validation
      image_files = HathiTrust::Validation::Image.image_files(@sip.files)
      return no_images_error if image_files.empty?

      bad_filenames = image_files.select{|filename| is_valid_filename? filename}
      bad_filenames.map do |filename|
        create_error(
          validation: :image_filename,
          human_message: "Base filename of #{filename} is not numeric only.",
          extras: { filename: filename }
        )
      end
    end

    private
    # Convenience method to create the error in the event of an error
    # which obviates the rest of the logic
    def no_images_error
        create_error(
          validation: :image_sequence,
          human_message: "No image filenames recognized.",
          extras: { image_count: 0 }
        )
    end

    def is_valid_filename?(filename)
      File.basename(filename) =~ /^\d+$/
    end
  end
end
