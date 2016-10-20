# frozen_string_literal: true

module HathiTrust::Validation::Image
  class Sequence < HathiTrust::Validation::Base
    def perform_validation
      image_files = HathiTrust::Validation::Image.image_files(@sip.files)
      return no_images_error if image_files.empty?

      sequence = sequence_files image_files
      missing = missing_values sequence
      duplicates = duplicate_values sequence

      missing_errors = missing.map{|value| missing_error_for value}
      duplication_errors = duplicates.map{|value| duplication_error_for value}

      return missing_errors + duplication_errors
    end

    private 

    # Find missing counting numbers between 1 and array max
    def missing_values(array)
      expected = Range.new(1, array.max)
      missing_vals = expected.reject{|val| array.include? val}
    end

    # Find duplicate values in an array
    #   Trick is to group by value to get hash of arrays. e.g 
    #   [1,2,2,3].group_by{|val| val} gives you {1=>[1], 2=>[2, 2], 3=>[3]}
    def duplicate_values(array)
      array.group_by{ |val| val }
           .select { |k, v| v.size > 1 }
           .keys
    end

    # @param filenames [Array] image filenames with extension
    # @return [Array] integer sequence sorted
    def sequence_files(filenames=[]) 
      filenames.map{|filename| File.basename(filename, ".*").to_i }.compact.sort
    end

    def no_images_error
        create_error(
          validation: :image_sequence,
          human_message: "No image filenames recognized.",
          extras: { image_count: 0 }
        )
    end

    def missing_error_for(value)
      formatted_value = sprintf("%.8d",value)
      create_error(
        validation: :image_sequence,
        human_message: "Image sequence missing #{formatted_value}",
        extras: { image_number: formatted_value }
      )
    end

    def duplication_error_for(value)
      formatted_value = sprintf("%.8d",value)
      create_error(
        validation: :image_sequence,
        human_message: "Image sequence duplication of #{formatted_value}",
        extras: { image_number: formatted_value }
      )
    end
  end
end
