# frozen_string_literal: true

require "zip"
require "set"

module HathiTrust::SIP
  CHECKSUM_FILE = "checksum.md5"
  META_FILE = "meta.yml"

  FILE_GROUP_EXTENSIONS = {
    image: [".jp2", ".tif"],
    ocr: [".txt"],
    coord_ocr: [".xml", ".html"]
  }.freeze

  NON_GROUP_FILES = [CHECKSUM_FILE, META_FILE, "marc.xml"].freeze

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
        zip_file.select { |e| !e.name_is_directory? }
          .map(&:name)
          .map { |e| File.basename(e) }.to_set
      end
    end

    # @return [Array] all paths (files and directories) inside the SIP
    def paths
      @paths ||= open_zip { |z| z.map(&:name) }
    end

    # @return [Hash] the parsed meta.yml from the SIP
    def metadata
      @metadata ||= if files.include?(META_FILE)
        file_in_zip(META_FILE) do |file|
          ensure_hash(SIP.load_yaml(file.read))
        end
      else
        {}
      end
    end

    # @return [String] The raw contents of the checksum file, or an empty string if there is no checksum file
    def raw_checksums
      if files.include?(CHECKSUM_FILE)
        file_in_zip(CHECKSUM_FILE) { |file| file.read }
      else
        ""
      end
    end

    # @return [Checksums] the checksums from checksum.md5 in the SIP
    def checksums
      @checksums ||= if files.include?(CHECKSUM_FILE)
        file_in_zip(CHECKSUM_FILE) do |file|
          Checksums.new(file.read)
        end
      else
        Checksums.new("")
      end

      @checksums ||= Checksum.new(raw_checksums)
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

    # @return [Array] sub-set of filenames in a given group
    def group_files(group)
      raise ArgumentError, "No such file group #{group}" unless FILE_GROUP_EXTENSIONS.key?(group)

      files.select { |f| FILE_GROUP_EXTENSIONS[group].include? File.extname(f) }
        .reject { |f| NON_GROUP_FILES.include? f }
        .sort
    end

    def each_file
      open_zip do |zip_file|
        zip_file.select { |e| !e.name_is_directory? }.each do |entry|
          yield [File.basename(entry.name), entry.get_input_stream]
        end
      end
    end

    def self.load_yaml(*args)
      ast = Psych.parse(*args)
      return false unless ast

      class_loader = Psych::ClassLoader.new
      Psych::Visitors::ToRuby.new(NoTimeScanner.new(class_loader),
        class_loader).accept(ast)
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

  class NoTimeScanner < Psych::ScalarScanner
    # Don't try to actually parse the time.
    def parse_time(string)
      string
    end
  end
end
