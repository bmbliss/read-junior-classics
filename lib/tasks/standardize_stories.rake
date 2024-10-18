desc 'Standardize story file names'
task standardize_stories: :environment do
  stories_dir = Rails.root.join('stories')
  standardized_count = 0
  total_files = 0

  Dir.glob(File.join(stories_dir, '**', '*.txt')).each do |file|
    total_files += 1
    dirname = File.dirname(file)
    filename = File.basename(file, '.txt')
    
    parts = if filename.include?('_')
              filename.split('_')
            else
              filename.split(' ')
            end

    new_parts = parts.filter_map do |p|
      next if p.blank?

      p.strip.titleize.gsub(' ', '_')
    end

    new_filename = new_parts.join('_') + '.txt'

    new_path = File.join(dirname, new_filename)

    if file != new_path
      File.rename(file, new_path)
      standardized_count += 1
      puts "Renamed: #{filename}.txt -> #{new_filename}"
    end
  end

  puts "Finished standardizing story filenames."
  puts "Standardized #{standardized_count} out of #{total_files} files."
end