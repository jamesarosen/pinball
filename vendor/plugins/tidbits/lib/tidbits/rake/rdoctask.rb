require 'rake/rdoctask'

module Tidbits #:nodoc:
  module Rake #:nodoc:
    class RDocTask < ::Rake::RDocTask
      
      # Extra files to be copied in to +rdoc_dir+/files/ but not run through RI.
      attr_reader :extra_files
      attr_accessor :error_io
      
      # Define RDoc tasks.
      # @param name: the name of the task to generate RDoc
      # @param error_io: an IO for error messages (defaults to $stderr)
      def initialize(name = :rdoc)
        @extra_files = ::Rake::FileList.new
        super(name)
      end
      
      def define
        super
        
        generate_extra_filenames_list
        copy_extra_files_task = paste(name, '_copy_extra_files')
        write_extra_links_task = paste(name, '_write_extra_links')
        
        task copy_extra_files_task do
          files_dir = File.join(rdoc_dir, 'files')
          mkdir files_dir unless File.exists?(files_dir)
          extra_files.each do |f|
            cp f, files_dir
          end
        end
        
        task write_extra_links_task do
          file_index = File.join(rdoc_dir, 'fr_file_index.html')
          raise "RDoc has not generated #{file_index}" unless File.exists?(file_index)
          File.open(file_index, 'r+') do |f|
            f.write filename_list_with_extra_files(f.read)
          end
        end
        
        # append copy_extra_files and write_extra_links to rdoc_target
        task rdoc_target do
          Rake::Task[copy_extra_files_task].invoke
          Rake::Task[write_extra_links_task].invoke
        end
      end

      private
      
      def extra_filenames_list
        @extra_filenames_list ||= generate_extra_filenames_list
      end
      
      def generate_extra_filenames_list
        result = []
        extra_files.to_a.each do |f|
          name = File.basename(f)
          error_io << "WARNING: multiple files named #{name}" if result.include?(name)
          result << name
        end
      end
      
      def filename_list_with_extra_files(html)
        html.gsub(/<div id=.index-entries.>/, "<div id='index-entries'>" + extra_files_as_html)
      end
      
      def extra_files_as_html
        result = ''
        extra_filenames_list.each do |f|
          result << "\n    <a href='files/#{f}'>#{f}</a><br />"
        end
        result
      end
      
    end
  end
end