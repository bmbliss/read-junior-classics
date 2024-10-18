require 'fileutils'

desc 'Update content for existing literary works'
task literary_work_content: :environment do
  def find_matching_story_file(title, author)
    stories_dir = Rails.root.join('stories')
    normalized_title = normalize_title(title)
    normalized_author = normalize_author(author)
  
    Dir.glob(File.join(stories_dir, '**', '*.txt')).find do |file|
      filename = File.basename(file, '.txt')
      parts = filename.split('_By_')

      file_author = parts.pop
      file_title = parts.join("_By_")

      normalized_file_title = normalize_title(file_title)
      normalized_file_author = normalize_author(file_author)
  
      normalized_file_title == normalized_title && normalized_file_author == normalized_author
    end
  end
  
  def normalize_title(str)
    str.downcase.gsub(/[^a-z]/, '')
  end

  def normalize_author(author)
    return "" unless author

    splitter = if author.include?('_')
                  "_"
                else
                  " "
                end

    parts = author.split(splitter)
    filtered_parts = parts.reject { |p| p.empty? || p =~ /\A\d+\Z/ }

    if filtered_parts.count > 2
      # remove the middle name
      last = filtered_parts.pop
      middle = filtered_parts.pop
      filtered_parts << last
    end

    filtered_parts.join.downcase.gsub(/[^a-z]/, '')
  end

  total_works = LiteraryWork.count
  updated_works = 0

  LiteraryWork.find_each.with_index do |work, index|
    story_file = find_matching_story_file(work.title, work.author)
    
    if story_file
      content = File.read(story_file)
      work.update(content: content)
      updated_works += 1

      # file_parts = story_file.split('/')
      # file_name = file_parts.pop
      # volume_dir = file_parts.pop

      # move the file to the stories/volumeX/matched folder
      # matched_dir = Rails.root.join('stories', volume_dir, 'matched')
      # FileUtils.mkdir_p(matched_dir)
      # FileUtils.mv(story_file, matched_dir)
      # puts "Updated content for '#{work.title}' by #{work.author}"
    else
      puts "No matching story file found for '#{work.title}' by #{work.author} volume #{work.volume}"
    end

    # if (index + 1) % 100 == 0
    #   puts "Processed #{index + 1} of #{total_works} works"
    # end
  end

  not_found_works = total_works - updated_works
  puts "Finished updating literary works."
  puts "Updated #{updated_works} out of #{total_works} works."
  puts "#{not_found_works} works did not have matching story files."
end
