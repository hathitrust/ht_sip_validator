# frozen_string_literal: true

module HathiTrust::Validator::Image
  class Count < HathiTrust::Validator::Base

    def perform_validation
      image_files = @sip.group_files(:image)
      if image_files.count != text_files.count
        create_error(
          validation_type: :image_count,
          human_message: "Number of images: #{image_files.count}"\
                         " does not match number of text files: #{text_files.count}.",
          extras: { image_count: image_files.count,
                    text_count: text_files.count }
        )
      end
    end

    private

    # Convenience method for getting subset of sip files that end in .txt
    def text_files
      @sip.files.select {|filename| File.extname(filename).casecmp(".txt").zero? }
    end

  end
end
