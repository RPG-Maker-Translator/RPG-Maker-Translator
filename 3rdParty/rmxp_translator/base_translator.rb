require 'json'
require 'pathname'
require_relative 'util'

# The base class for translation. The VX and VX Ace translators are just
# instances of this class with different RPG data structures loaded.
class BaseTranslator
  def initialize
    @dest_path = Pathname.new("")
  end

  # Sets the destination of any generated files.
  def set_destination(dest)
    @dest_path = Pathname.new(dest)

    unless @dest_path.exist?
      Util::Log.show_error("The given destination directory does not exist!")
      exit
    end

    unless @dest_path.directory?
      Util::Log.show_error("The given destination is not a directory!")
      exit
    end
  end

  # Parses the command line flags and executes any commands given.
  def do_commands(args)
    show_usage = false
    unknown_arg = false
    dump_cmds = []
    translate_cmds = []
    update_cmds = []

    # Parse each argument.
    args.each do |arg|
      arg_parts = arg.split('=', 2)

      # Arguments without value.
      if arg_parts.length == 1
        case arg_parts[0]
          when "--help" then show_usage = true
          when "-h" then show_usage = true
          else unknown_arg = true
        end
      # Arguments with value.
      elsif arg_parts.length == 2
        value = arg_parts[1]
        case arg_parts[0]
          when "--dump" then dump_cmds.push(value)
          when "--translate" then translate_cmds.push(value)
          when "--update" then update_cmds.push(value)
          when "--dest" then set_destination(value)
          else unknown_arg = true
        end
       else
        unknown_arg = true
      end

      if unknown_arg
        Util::Log.show_error("Unknown argument #{arg}!")
        return
      end
    end

    # If --help was given, or no commands, show usage information and quit.
    if show_usage or (dump_cmds.empty? and translate_cmds.empty? and update_cmds.empty?)
      print_usage
      exit
    end

    # Execute the given commands.
    dump_cmds.each {|pattern| dump_files(pattern)}
    translate_cmds.each {|pattern| translate_files(pattern)}
    update_cmds.each {|pattern| update_files(pattern)}
  end
              
  def dump_files(pattern)
    Pathname.glob(pattern).each {|path| dump_file(path)}
  end

  def translate_files(pattern)
    Pathname.glob(pattern).each {|path| translate_file(path)}
  end

  def update_files(pattern)
    Pathname.glob(pattern).each {|path| update_file(path)}
  end

  def dump_file(path)
    print "Dumping #{path}... "

    # Make sure we don't accidentally overwrite a translation file.
    json_path = @dest_path.join(path.basename.sub_ext('.json'))

    if json_path.exist?
      puts "Warning: The translation file #{json_path} already exists, overwrite? a/y/N"
      answer = STDIN.gets.chomp

      if answer == "a"
        puts "Aborting"
        exit
      elsif answer != "y"
        return
      end
    end

    # Load the file using marshaling.
    Util::File::check_readable(path)
    data = Marshal.load(File.binread(path))

    # Preprocess the data before dumping it.
    if Script::data_is_script?(data)
      scripts_path = @dest_path.join("scripts")

      unless scripts_path.exist?
        Dir.mkdir(scripts_path)
      end

      # Create an array of Script instances from the loaded data.
      data = data.map.with_index do |script, i|
        Script.new(script[0], script[1], script[2], scripts_path, i)
      end
    elsif data.instance_of?(Hash)
      # Sort hashes so we get the entries in some kind of order.
      data = data.sort
    elsif data.instance_of?(Array)
      # If the loaded data is an array, annotate each entry with its index in
      # the RPG Maker database. This is just to make it easier to see what each
      # JSON entry correponds to in RPG Maker.
      data = data.map.with_index {|e, i| [i, e]}
    end

    # Dump the data to a JSON file.
    Util::File.check_writable(json_path)
    File.binwrite(json_path, JSON.pretty_generate(data))
    puts "ok"
    self
  end

  def translate_file(path)
    print "Translating #{path}... "
    
    json_path = path.sub_ext('.json')
    unless json_path.exist?
      # Ignore missing translation files.
      puts "translation missing, ignoring."
      return
    end

    # Load the original data.
    Util::File.check_readable(path)
    original = Marshal.load(File.binread(path))

    # Load the translation file.
    Util::File.check_readable(path)
    translation = JSON.load(File.binread(json_path))
    
    # Translate each instance in the original data.
    if Script::data_is_script?(original)
      scripts_path = path.dirname.join('scripts')
      original = original.zip(translation).map.with_index do |e, i|
        script, tran = e
        script = Script.new(script[0], script[1], script[2], scripts_path, i)
        script.translate(tran, Util::Info.new("Script", i))
      end
    elsif original.instance_of?(Hash)
      translation.each.with_index do |t, i|
        o = original[t[0]]
        o.translate(t[1], Util::Info.new(o.class.name, i))
      end
    elsif original.instance_of?(Array)
      original = original.zip(translation).map.with_index do |e, i|
        orig, tran = e
        orig.translate(tran[1], Util::Info.new(orig.class.name, i)) unless orig.nil?
        orig
      end
    elsif original.respond_to?('translate')
      original = original.translate(translation, Util::Info.new(original.class.name, 1))
    else
      Util::Log::show_error("Unknown data!")
    end

    tran_path = @dest_path.join(path.basename)
    Util::File.check_writable(tran_path)

    # Check that we're not trying to overwrite the original data file, since a
    # translation file can't be applied to an already translated data file.
    if tran_path.exist? and tran_path.realpath == path.realpath
      puts "Warning: The destination is the same as the original data file, overwrite? a/y/N?"
      answer = STDIN.gets.chomp

      if answer == "a" then
        puts "Aborting"
        exit
      elsif answer != "y" then
        puts "Skipping #{path}"
        return
      end
    end

    # Dump the translated data.
    File.binwrite(tran_path, Marshal.dump(original))
    puts "ok"
    self
  end

  def update_file(path)
    print "Updating #{path}..."

    # If no translation file exists, create a new one instead of updating.
    json_path = path.sub_ext('.json')
    unless json_path.exist?
      puts " no existing translation, dumping instead."
      dump_file(path)
      return
    end

    # Load the original data.
    Util::File.check_readable(path)
    original = Marshal.load(File.binread(path))

    # Load the translation data.
    Util::File.check_readable(json_path)
    translation = JSON.load(File.binread(json_path))

    # Update the translation.
    if Script.data_is_script?(original)
      scripts_path = path.dirname.join('scripts')
      original = original.zip(translation).map.with_index do |e, i|
        script, tran = e
        script = Script.new(script[0], script[1], script[2], scripts_path, i)
        script.update(tran, Util::Info.new("Script", i))
      end
    elsif original.instance_of?(Hash)
      ut = Hash[translation.map {|k, v| [k, v]}]
      original.each do |i, o|
        t = ut[i]
        ut[i] = t.nil? ? o : o.update(t, Util::Info.new(o.class.name, i))
      end
      translation = ut.sort
    elsif original.instance_of?(Array)
      translation = original.zip(translation).map.with_index do |e, i|
        orig, tran = e

        if tran.nil? or orig.nil?
          [i, orig]
        else
          tran[1] = orig.update(tran[1], Util::Info.new(orig.class.name, i))
          tran
        end
      end
    end

    # Dump the updated translation file.
    json_path = @dest_path.join(path.basename.sub_ext('.json'))
    Util::File.check_writable(json_path)
    File.binwrite(json_path, JSON.pretty_generate(translation))
    puts "ok"
  end
end
