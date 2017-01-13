# Some utility stuff.

module Util
  # A class used to store information about what element is being processed, for
  # error reporting.
  class Info
    def initialize(name, index)
      @elements = [[name, index]]
    end

    def add(name, index = -1)
      info = Info.new(name, index)
      info.elements.concat @elements 
      info
    end

    def dump
      @elements.reverse_each do |e|
        print "  from element #{e[0]}"
        print " with index #{e[1]}" unless e[1] == -1
        print "\n"
      end
    end

    attr_accessor :elements
  end

  # Some message printing functions.
  class Log
    def self.show_message(header, msg, info)
      puts "#{header}: #{msg}"
      info.dump unless info.nil?
    end

    def self.show_error(msg, info = nil)
      show_message("Error", msg, info)
    end

    def self.show_warning(msg, info = nil)
      show_message("Warning", msg, info)
    end

    def self.show_info(msg, info = nil)
      show_message("Info", msg, info)
    end
  end

  # Some file utility functions.
  class File
    # Checks that a file path is readable.
    def self.check_readable(path)
      unless path.exist?
        Util::Log.show_error("#{path} does not exist!")
        exit
      end

      unless path.readable?
        Util::Log.show_error("No permission to access #{path}!")
        exit
      end
    end

    # Checks that a file path is writable.
    def self.check_writable(path)
      unless path.dirname.writable?
        Util::Log.show_error("No permission to write to #{path}!")
        exit
      end

      if path.exist? and not path.writable?
        Util::Log.show_error("No permission to write to #{path}!")
        exit
      end
    end
  end
end

# Prints out usage information about this tool.
def print_usage
  puts "Usage: #{$PROGRAM_NAME} [flags]"
  puts " --dump=pattern         Dumps all files matching pattern."
  puts " --translate=pattern    Translates all files matching pattern."
  puts " --update=pattern       Updates all files matching pattern."
  puts " --dest                 Sets the destination folder for generated files."
  puts " --help                 Shows this text."
end
