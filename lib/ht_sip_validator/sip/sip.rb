# frozen_string_literal: true
require "zip"
require "yaml"

module HathiTrust::SIP
  CHECKSUM_FILE = "checksum.md5"
  META_FILE = "meta.yml"

  # A HathiTrust simple SIP file, packaged as zip
  class SIP
    # Initialize a SubmissionPackage given an existing file
    # @param [String] zip_file_name The path to the SIP package
    def initialize(zip_file_name)
      @zip_file_name = zip_file_name
      @extraction_dir = nil
    end

    # @return [Array] a list of file names in the SIP
    def files
      @files ||= open_zip do |zip_file|
        zip_file.select {|e| !e.name_is_directory? }
          .map(&:name)
          .map {|e| File.basename(e) }
      end
    end

    # @return [Hash] the parsed meta.yml from the SIP
    def meta_yml
      @meta_yml ||= file_in_zip(META_FILE) do |file|
        YAML.load(file.read)
      end
    end

    # @return [Checksums] the checksums from checksum.md5 in the SIP
    def checksums
      @checksums ||= file_in_zip(CHECKSUM_FILE) do |file| 
        Checksums.new(file)
      end
    end

    # Extracts the files to a temporary directory and passes
    # the directory to the given block. Automatically cleans
    # up before extract returns.
    # @return [String] the directory files were extracted to
    def extract
      Dir.mktmpdir do |dir|
        open_zip do |zip_file|
          zip_file.each do |entry|
            unless entry.name_is_directory?
              entry.extract(File.join(dir, File.basename(entry.name)))
            end
          end

          yield dir
        end
      end
    end

    private

    def file_in_zip(file_name)
      open_zip do |zip_file|
        yield zip_file.glob("**/#{file_name}").first.get_input_stream
      end
    end

    def open_zip(&block)
      Zip::File.open(@zip_file_name, &block)
    end
  end
end
