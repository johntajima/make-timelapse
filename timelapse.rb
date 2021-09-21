#!/usr/bin/env ruby
require 'optionparser'

#
# Make timelapse of directory of jpgs.
#
# > timelapse <source path> [options]
#
# options:
#   default output file is date of last jpg file in 
#   YYYYMMDD.mp4 format.
#
#  -o  outputfile
#  -q  crf quality (default 17)
#  -r  frame rate (default 24)
#  -v  encoding format (default libx264)
#  -s  size (default 3280x2464)

options = {}
options[:quality]   = 17
options[:framerate] = 30
options[:size]      = '3280x2464' # pi camera v2 max size
#options[:size]      = '1440x1080' # pi camera v2 max size
options[:encoding]  = 'libx264'
options[:force]     = false
options[:path]      = ''

root_path = ARGV.first
path      = File.expand_path(root_path)

def make_timelapse(path, options = {})
  if options[:input]
    infile = "-f concat -i #{options[:input]}"
  else
    infile = "-pattern_type glob -i '#{File.join(path, "*.jpg")}'"
  end
  outfile = options[:outfile] ? options[:outfile] :   set_outfile(path)
  cmd = "ffmpeg -framerate #{options[:framerate]} #{infile} -s:v #{options[:size]} -c:v #{options[:encoding]} -crf #{options[:quality]} -pix_fmt yuv420p '#{outfile}'"
  system(cmd)
end

def set_outfile(path)
  puts "set output file in path [#{path}]"
  last = Dir.glob(File.join(path, "*.jpg")).last
  raise StandardError, "No valid input files found in #{path}" unless last

  outfile = File.join(path, File.ctime(last).strftime("%Y%m%d.mp4"))
rescue StandardError => e
  STDERR.puts e
  exit(1)
end

OptionParser.new do |opts|
  opts.banner = "Usage: make-timelapse.rb PATH [options]\n"
  opts.on('-q', '--quality QUALITY', "set CRF encoding quality (default 17)") do |quality|
    options[:quality] = quality.to_i
  end
  opts.on('-s', '--size SIZE', "output size (WxH) (default 3280x2464)") do |size|
    options[:size] = size
  end
  opts.on('-r', '--framerate RATE', "framerate (default 24)") do |rate|
    options[:framerate] = rate
  end
  opts.on('-v', '--encoding ENCODING', "encoding (default libx264)") do |encoding|
    options[:encoding] = encoding
  end
  opts.on('-o', '--outfile FILE', "output filename (default YYYMMDD.mp4)") do |filename|
    options[:outfile] = File.expand_path(filename)
  end
  opts.on('-i', '--input-paths INPUT', "comma-separated list of paths of input files") do |input|
    paths = input.split(",")
    file = paths.map do |path|
      cmd = File.join(File.expand_path(path), "*.jpg")
      "file #{cmd}"
    end.join("\n")
  end
end.parse!



if !File.exist?(path) 
  STDERR.puts "[#{path}] is invalid."
  exit(1)
end

make_timelapse(path, options)

