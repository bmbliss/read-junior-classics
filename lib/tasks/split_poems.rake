require 'rake'

desc "Split poems from each junior classic volume into separate files"
task :split_poems do
  vol_file = "volume10.txt"
  content = File.read("volumes/#{vol_file}")

  clean_content = content.gsub(/^\d+\n^[A-Z\s\W]+$/, "\n")
  
  # Split the content into stories
  # stories = content.split(/^(?:[A-Z][A-Z\s,.'-]*[A-Z])$\n^By\s.+/)
  stories = clean_content.split(/\n(.*)\nBy (.*)\n/)
  
  # Remove the first element (text before the first story)
  stories.shift
  
  # Process each story
  stories.each_slice(3) do |title, author, story_text|
    title = title.strip
    author = author.strip
    story_text = story_text.strip
    
    # Create a filename from the title and author
    filename = "#{title} by #{author}.txt".gsub(/[^0-9A-Za-z.\-]/, '_')
    filename = "stories/#{vol_file.split('.').first}/#{filename}"
    
    # Ensure the stories directory exists
    FileUtils.mkdir_p("stories/#{vol_file.split('.').first}")
    
    # Write the story to a file
    File.open(filename, 'w') do |file|
      file.puts story_text #.gsub("\n\n", "<p>").gsub("\n", " ").gsub("<p>", "\n\n")
    end
    
    # TODO 
    # clean up all the newlines and whitespace
    # remove the title and author from the story
    
    puts "Saved: #{filename}"
  end
end
