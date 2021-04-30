#!/usr/bin/env ruby

# run script that creates a mp4 file from all jpgs in /year/month/day/ directory
# -s:v 2592x1944
# -s:v 1920
# Default is today @ default resolution 24fps 

# > make_timelapse.rb <input> <output> -r 2592x1944 -c libx264 -q 17 -f 24
#   default output is <date>.mp4
# > make_timelapse.rb today 
# > make_timelapse.rb yesterday <output>


ROOT = "/Volumes/Media/deathstar/pi3"
CMD = 'ffmpeg -framerate 24 -pattern_type glob -i "<PATH>" -s:v 2592x1944 -c:v libx264 -crf 17 -pix_fmt yuv420p <OUTPUT>'
YESTERDAY = 24 * 60 * 60
time =  Time.now # - YESTERDAY
year,mon,day = time.year.to_s, '%02d' % time.month, '%02d' % time.day

target_movie = File.join(ROOT, "#{year}#{mon}#{day}.mp4")
jpg_path     = File.expand_path(File.join(ROOT, year, mon, day ,"/*.jpg"))

# get options
# set input files
  # default today
  # 
# set output file
# set params for ffmpeg command


cmd = CMD.gsub("<PATH>", jpg_path).gsub("<OUTPUT>", target_movie)
puts "Path: #{jpg_path}"
resp = system(cmd)
puts resp