require 'rake'

desc "Split stories from each junior classic volume into separate files"
task :split_stories do
  Dir.foreach('volumes') do |vol_file|
    next if vol_file == '.' or vol_file == '..'

    content = File.read("volumes/#{vol_file}")
    
    # Split the content into stories
    stories = content.split(/\n\n(.*)\n\nBy (.*)\n\n/) # for others
    # stories = content.split(/\n\n(.*)\n\n\nBy (.*)\n\n/) # for volume 1
    
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
        file.puts story_text.gsub("\n\n", "<p>").gsub("\n", " ").gsub("<p>", "\n\n")
      end
      
      # TODO 
      # clean up all the newlines and whitespace
      # remove the title and author from the story
      
      puts "Saved: #{filename}"
    end
  end
end
