require 'fileutils'

task :nationals do
  content = File.read("stories/volume10/nationals.txt")

  # split up the content into separate lines
  poems = content.split("\n\n")

  # loop over the poems and save to their own files
  poems.each_with_index do |poem, index|
    next if poem.empty?

    lines = poem.split("\n")

    title = lines.shift
    filename = "#{title.strip}_by_unknown".gsub(/[^0-9A-Za-z.\-]/, ' ').strip.gsub(" ", "_")
    File.write("stories/volume10/#{filename}.txt", lines.join("\n"))
  end
end
