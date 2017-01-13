require 'zlib'
require_relative 'util'
require_relative 'tran_util'

# Some data structures that are common to both VX and VX Ace.

class Rect
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end

  class << self
    def _load(s)
    end
  end
end

class Tone
  def initialize(red, green, blue, gray = 0.0)
    @red = red
    @green = green
    @blue = blue
    @gray = gray
  end

  def _dump(d = 0)
    [@red].pack('d') + [@green].pack('d') + [@blue].pack('d') + [@gray].pack('d')
  end

  class << self
    def _load(s)
      red = s[0,8].unpack('d')[0]
      blue = s[8,8].unpack('d')[0]
      green = s[16,8].unpack('d')[0]
      gray = s[24,8].unpack('d')[0]
      Tone.new(red, blue, green, gray)
    end
  end
end

class Color
  def initialize(red, green, blue, alpha = 255.0)
    @red = red
    @green = green
    @blue = blue
    @alpha = alpha
  end

  def _dump(d = 0)
    [@red].pack('d') + [@green].pack('d') + [@blue].pack('d') + [@alpha].pack('d')
  end

  class << self
    def _load(s)
      red = s[0,8].unpack('d')[0]
      blue = s[8,8].unpack('d')[0]
      green = s[16,8].unpack('d')[0]
      alpha = s[24,8].unpack('d')[0]
      Color.new(red, blue, green, alpha)
    end
  end
end

class Table
  def initialize(x, y = nil, z = nil)
    @dims = 1 + (y.nil?() ? 0:1) + (z.nil?() ? 0:1)
    @xsize = x
    @ysize = y.nil?() ? 1:y
    @zsize = z.nil?() ? 1:z
    @data=Array.new(@xsize*@ysize*@zsize, 0)
  end

  def [](x, y = 0, z = 0)
    @data[x + y*@xsize + z*@xsize*@ysize]
  end

  def []=(*args)
    x = args[0]
    y = args.size>2 ? args[1]:0
    z = args.size>3 ? args[2]:0
    v = args.pop
    @data[x + y*@xsize + z*@xsize*@ysize]=v
  end

  def _dump(d = 0)
    s = [@dims].pack('L')
    s += [@xsize].pack('L') + [@ysize].pack('L') + [@zsize].pack('L')
    s += [@xsize*@ysize*@zsize].pack('L')

    for z in 0...@zsize
      for y in 0...@ysize
        for x in 0...@xsize
          s += [@data[x + y*@xsize + z*@xsize*@ysize]].pack('S')[0,2]
        end
      end
    end
    s
  end

  attr_reader(:xsize,:ysize,:zsize,:data)

  class << self
    def _load(s)
      dims = s[0,4].unpack('L')[0]
      nx = s[4,4].unpack('L')[0]
      ny = s[8,4].unpack('L')[0]
      nz = s[12,4].unpack('L')[0]
      data = []

      for i in 10...(s.size/2)
        data.push(s[i*2, 2].unpack('S')[0])
      end

      t = Table.new(nx, (dims >= 2 ? ny:nil), (dims >= 3 ? nz:nil))
      n = 0
      for z in 0...nz
        for y in 0...ny
          for x in 0...nx
            t[x, y, z] = data[n]
            n += 1
          end
        end
      end
      t
    end
  end
end

# Not actually an RPG Maker class, just for convenience.
class Script
  def initialize(index, name, text, scripts_path, script_idx)
    @index = index
    @name = name
    @text = Zlib::Inflate.inflate(text).force_encoding('UTF-8')
    script_name = "Script" + script_idx.to_s.rjust(3, "0")
    @file = scripts_path.join(script_name).sub_ext(".rb")
  end

  def to_json(*a)
    File.binwrite(@file, @text)
    File.binwrite(@file.sub_ext('_tran.rb'), @text)

    {
      'json_class' => self.class.name,
      'filename' => @file,
      'name' => dump_string(@name),
    }.to_json(*a)
  end

  def translate(trans, info)
    @name = translate_string("name", @name, trans, info)

    filename = Pathname.new(trans["filename"])
	puts "READING #{filename}"
    o = File.binread(filename).force_encoding('UTF-8')

    # Check that the script hasn't changed in the database.
    if o != @text
      o_lines = o.split(/\r?\n/)
      t_lines = @text.split(/\r?\n/)
      o_lines.zip(t_lines).each.with_index do |e, i|
        ol, tl = e
        if ol != tl
          msg =  "Invalid script translation for #{@file}!\n"
          msg += "  Got translated line #{i}:\n"
          msg += "    #{tl}\n"
          msg += "  Expected:\n"
          msg += "    #{ol}\n\n"
          msg += "  This means that you've either changed the Script.rvdata and need to --update it,\n"
          msg += "  or accidentally changed an original script instead of the _tran.rb file."
          Util::Log.show_error(msg)
          exit
        end
      end
      Util::Log.show_error("Invalid script translation for #{@file}, but could find no difference. This should not happen!")
      exit
    else
      # Otherwise, replace the script with the translated script, if it exists.
      if filename.exist?
        @text = File.binread(filename.sub_ext('_tran.rb')).force_encoding('UTF-8')
      end
    end

    zipped_text = Zlib::Deflate.deflate(@text)
    [@index, @name, zipped_text]
  end

  def update(tran, info)
    return self if tran.nil?
      
    @name = update_string("name", @name, tran, info)

    filename = Pathname.new(tran["filename"])
    text = File.binread(filename)

    if @text != text.force_encoding('UTF-8') then
      Util::Log.show_info("Script ##{@file} has changed, removing translation.", info)
      File.binwrite(@file, @text)
      File.binwrite(@file.sub_ext('_tran.rb'), @text)
      self
    else
      tran
    end
  end

  def self.data_is_script?(data)
    data.instance_of?(Array) and data[0].instance_of?(Array) and data[0].length == 3
  end
end
