require 'rake'

desc "clean up the new lines in the stories"
task :clean_new_lines do
  stories_dir = Rails.root.join('stories')

  Dir.glob(File.join(stories_dir, '**', '*.txt')).each do |file|
    # dirname = File.dirname(file)
    # filename = File.basename(file, '.txt')
    
    # skip the poems
    next if file.include?("volume10")

    content = File.read(file)
    clean = content.gsub("\n\n", "<p>").gsub("\n", " ").gsub("<p>", "\n\n")

    File.write(file, clean)
  end
end
