# Represents a translatable string.
class TranslatableString
  def initialize(orig, tran = "")
    @original = orig.force_encoding('UTF-8')
    @translation = tran.force_encoding('UTF-8')
  end

  attr_accessor :original
  attr_accessor :translation

  def to_json(*a)
    {
      'json_class' => self.class.name,
      'original   ' => @original,
      'translation' => @translation
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o['original   '], o['translation'])
  end

  # Translates the given string.
  def apply(orig, info)
    eorig = String.new(orig).force_encoding('UTF-8')
    if @original != eorig
      msg =  "Invalid translation element!\n"
      msg += "  Got translation for:\n"
      msg += "    #{@original}\n"
      msg += "  Expected:\n"
      msg += "    #{eorig}\n"
      msg += "  Translation:\n"
      msg += "    #{@translation}"
      Util::Log.show_error(msg, info)
      exit
    end
      
    @translation.empty? ? orig : @translation
  end

  # Updates this translation string given the expected original string.
  def update(orig, info)
    if @original != String.new(orig).force_encoding('UTF-8')
      Util::Log.show_info("Removing translation from changed string #{@original}", info)
      @original = orig
      @original.force_encoding('UTF-8')
      @translation = ""
    end

    self
  end
end
      
class TranslatableArray
  def initialize(orig, tran = nil)
    @original = orig.map {|o| o.force_encoding('UTF-8')}
    @translation = tran.nil? ? Array.new(@original.length, "") : tran
  end

  attr_accessor :original
  attr_accessor :translation

  def to_json(*a)
    {
      'json_class' => self.class.name,
      'original   ' => @original,
      'translation' => @translation
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o['original   '], o['translation'])
  end

  def apply(orig, info)
    if orig.length != @original.length
      msg = "Invalid translation element!\n"
      msg += "  Got translation for list of #{@original.length} strings."
      msg += "  Expected list of #{orig.length}."
      msg += "  Translation: #{@translation}"
      Util::Log.show_error(msg, info)
      exit
    end

    @original.zip(orig).each do |o1, o2|
      eo = String.new(o2).force_encoding('UTF-8')
      if o1 != eo
        msg = "Invalid translation element!\n"
        msg += "  Got translation for:\n"
        msg += "    #{o1}\n"
        msg += "  Expected:\n"
        msg += "    #{eo}\n"
        Util::Log.show_error(msg, info)
        exit
      end
    end

    @translation.index {|t| not t.empty?} == nil ? orig : @translation
  end

  # Updates this translation string given the expected original string.
  def update(orig, info)
    eq = orig.length == @original.length

    if eq
      @original.zip(orig).each do |o1, o2|
        if o1 != String.new(o2).force_encoding('UTF-8')
          eq = false
          break
        end
      end
    end

    if not eq
      Util::Log.show_info("Removing translation from changed string #{@original}", info)
      @original = orig.map {|o| o.force_encoding('UTF-8')}
      @translation = Array.new(@original.length, "")
    end
    
    self
  end
end
    
# Helper function for dumping an array.
def dump_array(arr)
  arr.map do |e|
    if e.instance_of?(String) then dump_string(e)
    elsif e.instance_of?(Array)  then dump_array(e)
    else e
    end
  end
end

def dump_string(str)
  str.nil? ? nil : TranslatableString.new(str)
end

def dump_parameters(arr)
  strs = arr.select {|e| e.instance_of?(String)}
  strs.length != arr.length ? dump_array(arr) : TranslatableArray.new(strs)
end

# Utility functions for translating various data types.

def translate_string(name, orig, tran, info)
  tran = tran[name]
  tran.nil? ? orig : tran.apply(orig, info.add(name))
end
    
def translate_strings(orig, tran, info)
  orig.zip(tran).map do |o, t|
    if o.instance_of?(String) then t.apply(o, info)
    elsif o.instance_of?(Array) then translate_strings(o, t, info)
    else o
    end
  end
end

def translate_hash(name, orig, tran, info)
  tran = tran[name]

  if tran.nil?
    Util::Log.show_error("Missing attribute #{name}!", info)
    exit
  end

  tran.each do |t|
    orig[t[0]].translate(t[1], info.add(name, t[0])) unless t.nil?
  end
  orig
end

def translate_list(name, orig, tran, info)
  info = info.add(name)
  if tran.instance_of?(Hash)
    tran = tran[name]
  else
    tran = tran[1][name]
  end

  if tran.nil?
    Util::Log.show_error("Missing attribute #{name}!", info)
    exit
  end

  orig.zip(tran).each do |o, t|
    o.translate(t, info) unless o.nil? or t.nil?
  end  
  orig
end

def translate_array(name, orig, tran, info, skip_missing = false)
  info = info.add(name)
  tran = tran[name]

  if tran.nil?
    if skip_missing
      return orig
    else
      Util::Log.show_error("Missing attribute #{name}!", info)
      exit
    end
  end

  translate_strings(orig, tran, info)
end

def translate_parameters(name, orig, tran, info)
  tran = tran[name]
  return orig if tran.nil?
 
  if tran.instance_of?(Array)
    translate_strings(orig, tran, info.add(name))
  else
    tran.apply(orig, info)
  end
end

# Utility functions for updating various data types.

def update_string(name, orig, tran, info)
  t = tran[name]

  if t.nil?
    if orig.nil?
      tran[name] = nil
    else
      tran[name] = TranslatableString.new(orig, info)
    end
    return tran
  end 

  tran[name] = t.update(orig, info.add(name))
  tran
end

def update_strings(orig, tran, info)
  tran = orig.zip(tran).map do |o, t|
    if o.instance_of?(String) then t.nil? ? dump_string(o) : t.update(o, info)
    elsif o.instance_of?(Array) then update_strings(o, t, info)
    else o
    end
  end
  tran
end

def update_hash(name, orig, tran, info)
  ut = tran[name]

  return dump_array(orig.sort) if ut.nil?

  ut = Hash[ut.map {|k, v| [k, v]}]
  orig.each do |i, o|
    t = ut[i]

    if t.nil?
      ut[i] = o
    else
      ut[i] = o.update(t, info.add(name, i))
    end
  end

  tran[name] = ut.sort
  tran
end

def update_list(name, orig, tran, info)
  ut = tran[name]

  return orig if ut.nil?

  ut = orig.zip(ut).map.with_index do |e, i|
    o, t = e

    if t.nil?
      o
    else
      o.update(t, info.add(name, i))
    end
  end

  tran[name] = ut
  tran
end

def update_array(name, orig, tran, info)
  t = tran[name]
  tran[name] = t.nil? ? dump_array(orig) : update_strings(orig, t, info.add(name))
  tran
end

def update_parameters(name, orig, tran, info)
  t = tran[name]

  if t.nil?
    tran[name] = dump_array(orig)
  elsif t.instance_of?(Array)
    tran[name] = update_strings(orig, t, info.add(name))
  else
    tran[name] = t.update(orig, info.add(name))
  end

  tran
end
