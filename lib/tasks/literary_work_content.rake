require 'fileutils'

desc 'Update content for existing literary works'
task literary_work_content: :environment do
  def find_matching_story_file(title, author)
    stories_dir = Rails.root.join('stories')
    normalized_title = normalize_string(title)
    normalized_author = normalize_string(author)
  
    Dir.glob(File.join(stories_dir, '**', '*.txt')).find do |file|
      filename = File.basename(file, '.txt')
      file_title, file_author = filename.split('by')
      
      normalized_file_title = normalize_string(file_title)
      normalized_file_author = normalize_string(file_author)
  
      normalized_file_title.include?(normalized_title) && 
        normalized_file_author.include?(normalized_author)
    end
  end
  
  def normalize_string(str)
    str.downcase.gsub(/[^a-z]/, '')
  end

  total_works = LiteraryWork.count
  updated_works = 0

  LiteraryWork.find_each.with_index do |work, index|
    story_file = find_matching_story_file(work.title, work.author)
    
    if story_file
      content = File.read(story_file)
      work.update(content: content)
      updated_works += 1
      puts "Updated content for '#{work.title}' by #{work.author}"
    else
      puts "No matching story file found for '#{work.title}' by #{work.author}"
    end

    if (index + 1) % 100 == 0
      puts "Processed #{index + 1} of #{total_works} works"
    end
  end

  not_found_works = total_works - updated_works
  puts "Finished updating literary works."
  puts "Updated #{updated_works} out of #{total_works} works."
  puts "#{not_found_works} works did not have matching story files."
end
