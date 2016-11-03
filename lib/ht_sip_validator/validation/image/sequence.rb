# frozen_string_literal: true

module HathiTrust::Validation::Image
  class Sequence < HathiTrust::Validation::Base

    attr_accessor :image_files, :sequence

    def perform_validation
      @image_files = HathiTrust::Validation::Image.image_files(@sip.files).sort
      return no_images_error if image_files.empty?

      # filenames that have invalid sequence numbers.
      invalids = invalid_values sequence
      invalid_files = filenames_of_sequence_values(invalids)

      # filenames that have duplicate sequence numbers.
      duplicates = duplicate_values sequence
      duplicate_files = filenames_of_sequence_values(duplicates)

      # sequence values that are missing from sequence of image files.
      missing = missing_values sequence

      errors = Array.new
      errors += missing.map{|value| missing_error_for value}
      errors += invalid_files.map{|filename| invalid_error_for filename}
      errors += duplicate_files.map{|filename| duplication_error_for filename}

      return errors
    end

    private 

    def sequence_files(filenames=[]) 
      filenames.map{|filename| File.basename(filename, ".*").to_i }
    end

    def sequence
      @sequence ||= sequence_files image_files
    end

    def indexes_of_sequence_values(values)
      values.map{|value| sequence.each_index.select{|idx| sequence[idx] == value}}.flatten   
    end

    def filenames_of_sequence_values(values)
      indexes_of_sequence_values(values).map{|idx| image_files[idx]}.uniq
    end

    # Sequence problem discovery methods
    
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

    def invalid_values(array)
      array.select(&:zero?)
    end

    # Convenience methods for creating errors

    def no_images_error
        create_error(
          validation: :image_sequence,
          human_message: "No image filenames recognized.",
          extras: { image_count: 0 }
        )
    end

    def invalid_error_for(filename)
      create_error(
        validation: :image_sequence,
        human_message: "An in range image sequence number could not be deduced from #{filename}."
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

    def duplication_error_for(filename)
      create_error(
        validation: :image_sequence,
        human_message: "Image sequence duplication of #{filename}",
        extras: { image_number: filename }
      )
    end
  end
end
