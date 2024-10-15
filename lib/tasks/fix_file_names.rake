require 'fileutils'
require 'string/similarity'

desc 'Match remaining files by similarity and fix file names'
task match_remaining_files: :environment do
  def normalize_string(str)
    str.downcase.gsub(/[^a-z0-9]/, '')
  end

  def find_unmatched_files
    stories_dir = Rails.root.join('stories')
    Dir.glob(File.join(stories_dir, 'volume*', '*.txt')) - Dir.glob(File.join(stories_dir, 'volume*', 'matched', '*.txt'))
  end

  def find_possible_matches(filename)
    normalized_filename = normalize_string(filename)
    LiteraryWork.all.map do |work|
      normalized_work = normalize_string("#{work.title} by #{work.author}")
      similarity = String::Similarity.cosine(normalized_filename, normalized_work)
      [work, similarity]
    end.sort_by { |_, similarity| -similarity }.take(5)
  end

  def present_matches(file, matches)
    puts "\nFile: #{file}"
    matches.each_with_index do |(work, similarity), index|
      puts "#{index + 1}. '#{work.title}' by #{work.author} (Similarity: #{similarity.round(2)})"
    end
    puts "0. Skip this file"
    print "Enter your choice (0-#{matches.length}): "
    choice = STDIN.gets.chomp.to_i
    choice == 0 ? nil : matches[choice - 1][0]
  end

  def rename_and_move_file(file, work)
    new_filename = "#{work.title} by #{work.author}.txt".gsub(' ', '_')
    volume_dir = File.dirname(file)
    matched_dir = File.join(volume_dir, 'matched')
    FileUtils.mkdir_p(matched_dir)
    new_file_path = File.join(matched_dir, new_filename)
    FileUtils.mv(file, new_file_path)
    puts "Moved and renamed: #{new_file_path}"
  end

  unmatched_files = find_unmatched_files
  total_files = unmatched_files.count
  processed_files = 0

  unmatched_files.each do |file|
    filename = File.basename(file, '.txt')
    possible_matches = find_possible_matches(filename)

    if possible_matches.any?
      chosen_work = present_matches(file, possible_matches)
      if chosen_work
        chosen_work.update(content: File.read(file))
        rename_and_move_file(file, chosen_work)
        processed_files += 1
      end
    else
      puts "No matches found for: #{file}"
    end

    puts "Processed #{processed_files} out of #{total_files} files"
  end

  puts "Finished processing remaining files."
  puts "Matched and renamed #{processed_files} out of #{total_files} files."
end
