#!/usr/bin/env ruby

require_relative 'base_translator'
require_relative 'rmxp_db'

BaseTranslator.new.do_commands(ARGV)
