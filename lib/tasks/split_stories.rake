require 'rake'

desc "Split stories from volume6.txt into separate files"
task :split_stories do
  content = File.read('volume6.txt')

  # Split the content into stories
  stories = content.split(/\n\n([A-Z0-9'"\-\?,. ]+)\n\nBy ([^\n]+)\n\n/)

  # Remove the first element (text before the first story)
  stories.shift

  # Process each story
  stories.each_slice(3) do |title, author, story_text|
    title = title.strip
    author = author.strip
    story_text = story_text.strip

    # Create a filename from the title and author
    filename = "#{title} by #{author}.txt".gsub(/[^0-9A-Za-z.\-]/, '_')
    filename = "stories/#{filename}"

    # Ensure the stories directory exists
    FileUtils.mkdir_p('stories')

    # Write the story to a file
    File.open(filename, 'w') do |file|
      file.puts "#{title}\n\nBy #{author}\n\n#{story_text}"
    end

    puts "Saved: #{filename}"
  end
end
