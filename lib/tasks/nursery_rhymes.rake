require 'fileutils'

task :nursery_rhymes do
  content = File.read('volumes/nursery_rhymes.txt')

  # split up the content into separate lines
  poems = content.split("\n\n")

  # loop over the poems and save to their own files
  poems.each_with_index do |poem, index|
    next if poem.empty?

    title = poem.split("\n").first.strip
    filename = "#{title.strip}_by_anonymous".gsub(/[^0-9A-Za-z.\-]/, ' ').strip.gsub(" ", "_")
    File.write("nursery/#{filename}.txt", poem)
  end
end
