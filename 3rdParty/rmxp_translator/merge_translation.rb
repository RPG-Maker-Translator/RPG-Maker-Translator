#!/usr/bin/env ruby

require 'json'
require 'pathname'

def merge_file(path)
  unless path.exist?
    puts "Error: #{path} does not exist."
    return
  end

  puts "Merging #{path}"

  tran = JSON.parse(File.binread(path))
  merge(tran)
  File.binwrite(path, JSON.pretty_generate(tran))
end

def merge(tran)
  if tran.instance_of?(Hash)
    merge_hash(tran)
  elsif tran.instance_of?(Array)
    merge_array(tran)
  else
    tran
  end
end

def merge_commands(tran)
  merged_tran = []
  i = 0

  while i < tran.length
    cmd = tran[i]

    match_type = case cmd["type"]
      when "Show Text" then tran[i + 1]["type"] == "Show Text" ? "Show Text" : "Show Text More"
      when "Comment" then "Comment More"
      when "Script" then "Script More"
      else ""
    end

    if not match_type.empty? and tran[i + 1]["type"] == match_type
      params = cmd["parameters"]
      o = [params[0]["original   "]]
      t = [params[0]["translation"]]
      
      while tran[i+1]["type"] == match_type
        i += 1
        params = tran[i]["parameters"]
        o.push params[0]["original   "]
        t.push params[0]["translation"]
      end

      cmd = {
        "json_class" => "RPG::EventCommand",
        "type" => cmd["type"],
        "parameters" => {
          "json_class" => "TranslatableArray",
          "original   " => o,
          "translation" => t
        }
      }
    end

    merged_tran.push cmd
    i += 1
  end

  merged_tran
end

def merge_array(tran)
  tran.map! do |t|
    merge(t) 
  end
  tran
end

def merge_hash(tran)
  unless tran["commands"].nil?
    tran["commands"] = merge_commands(tran["commands"])
  else
    tran = tran.each do |k, v|
      tran[k] = merge(v)
    end
  end
  tran
end

ARGV.each {|arg| Pathname.glob(arg).each {|path| merge_file(path)}}
