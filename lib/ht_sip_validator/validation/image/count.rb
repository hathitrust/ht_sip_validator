# frozen_string_literal: true

module HathiTrust::Validation::Image
  class Count < HathiTrust::Validation::Base

    def perform_validation
      image_files = HathiTrust::Validation::Image.image_files(@sip.files)
      
      if image_files.count != text_files.count
        create_error(
          validation: :image_count,
          human_message: "Number of images: #{image_files.count}"\
                         " does not match number of text files: #{text_files.count}.",
          extras: { image_count: image_files.count,
                    text_count: text_files.count}
        )
      end
    end

    private

    # Convenience method for getting subset of sip files that end in .txt
    def text_files
      @sip.files.select{|filename| File.extname(filename).downcase == ".txt"}
    end

  end
end
