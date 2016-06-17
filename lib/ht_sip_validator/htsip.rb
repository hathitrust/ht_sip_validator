require 'zip'
require 'yaml'

module HathiTrust
  # A HathiTrust simple SIP file, packaged as z ip
  class SubmissionPackage
    def initialize(zip_file_name)
      @zip_file_name = zip_file_name
    end

    def files
      open_zip do |zip_file|
        zip_file.select { |e| !e.name_is_directory? }
                .map(&:name)
                .map { |e| File.basename(e) }
      end
    end

    def meta_yml
      open_zip do |zip_file|
        YAML.load(zip_file.glob('**/meta.yml').first.get_input_stream.read)
      end
    end

    def checksums
      checksums = {}
      open_zip do |zip_file|
        zip_file.glob('**/checksum.md5').first.get_input_stream
                .each_line do |line|
          line.match(/^([a-fA-F0-9]{32})(\s+\*?)(\S.*)/) do |m|
            (checksum, _, file) = m.captures
            checksums[file] = checksum
          end
        end
      end
      checksums
    end

    private

    def open_zip(&block)
      Zip::File.open(@zip_file_name, &block)
    end
  end
end
