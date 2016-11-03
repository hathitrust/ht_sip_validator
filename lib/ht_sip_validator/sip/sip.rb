# frozen_string_literal: true
require "zip"
require "yaml"
require "set"

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

    # @return [Set] a set of file names in the SIP
    def files
      @files ||= open_zip do |zip_file|
        zip_file.select {|e| !e.name_is_directory? }
          .map(&:name)
          .map {|e| File.basename(e) }.to_set
      end
    end

    # @return [Hash] the parsed meta.yml from the SIP
    def metadata
      @metadata ||= if files.include?(META_FILE)
                      file_in_zip(META_FILE) do |file|
                        ensure_hash(YAML.load(file.read))
                      end
                    else
                      {}
                    end
    end

    # @return [Checksums] the checksums from checksum.md5 in the SIP
    def checksums
      @checksums ||= if files.include?(CHECKSUM_FILE)
                       file_in_zip(CHECKSUM_FILE) do |file|
                         Checksums.new(file)
                       end
                     else
                       Checksums.new(StringIO.new(""))
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
            entry.extract(File.join(dir, File.basename(entry.name))) unless entry.name_is_directory?
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

    def ensure_hash(thing)
      if thing.is_a?(Hash)
        thing
      else
        {}
      end
    end
  end
end
