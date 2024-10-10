require 'fileutils'

task :fix_retold_by => :environment do
  Dir.glob('stories/**/*') do |file|
    if File.file?(file)
      volume = file.split('/').second

      content = File.read(file)

      old_content = []

      if content.include?('Retold by')
        stories = content.split(/\n\n (.*)\n\nRetold by (.*)/)

        # Remove the first element (text before the first story)
        old_content.push(stories.shift)

        stories.each_slice(3) do |title, author, story_text|
          title = title.strip
          author = author.strip
          story_text = story_text.strip

          if title.blank? || author.blank? || story_text.blank?
            puts "Skipping: #{title} by #{author}"

            old_content.push(title)
            old_content.push(author)
            old_content.push(story_text)
            next
          end
          
          # Create a filename from the title and author
          filename = "#{title} by #{author}.txt".gsub(/[^0-9A-Za-z.\-]/, '_')
          filename = "stories/#{volume}/#{filename}"
          
          # Write the story to a file
          File.open(filename, 'w') do |file|
            file.puts story_text.gsub("\n\n", "<p>").gsub("\n", " ").gsub("<p>", "\n\n")
          end

          File.write(file, old_content.join("\n"))
          
          puts "Saved: #{filename}"
        end
      end
    end
  end
end
