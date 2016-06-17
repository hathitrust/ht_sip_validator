require 'zip'
require 'yaml'
require 'ht_sip_validator/checksums'

module HathiTrust
  # A HathiTrust simple SIP file, packaged as zip
  class SubmissionPackage
    # Initialize a SubmissionPackage given an existing file
    #
    # @param [String] zip_file_name The path to the SIP package
    def initialize(zip_file_name)
      @zip_file_name = zip_file_name
      @extraction_dir = nil
    end

    # @return [Array] a list of file names in the SIP
    def files
      open_zip do |zip_file|
        zip_file.select { |e| !e.name_is_directory? }
                .map(&:name)
                .map { |e| File.basename(e) }
      end
    end

    # @return [Hash] the parsed meta.yml from the SIP
    def meta_yml
      open_zip do |zip_file|
        YAML.load(zip_file.glob('**/meta.yml').first.get_input_stream.read)
      end
    end

    # @return [Checksums] the checksums from checksum.md5 in the SIP
    def checksums
      open_zip do |zip_file|
        Checksums.new(zip_file.glob('**/checksum.md5').first.get_input_stream)
      end
    end

    # Extracts the files to a temporary directory and passes
    # the directory to the given block. Automatically cleans
    # up before extract returns.
    #
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

    def open_zip(&block)
      Zip::File.open(@zip_file_name, &block)
    end
  end
end
