namespace :stories do
  desc "Move matched stories back to volume folders and remove empty matched folders"
  task :reorganize => :environment do
    root_path = Rails.root.join('stories')
    
    Dir.glob(File.join(root_path, 'volume*')).each do |volume_path|
      matched_path = File.join(volume_path, 'matched')
      
      if Dir.exist?(matched_path)
        puts "Processing #{matched_path}..."
        
        # Move all files from matched folder to volume folder
        Dir.glob(File.join(matched_path, '*')).each do |file|
          FileUtils.mv(file, volume_path)
        end
        
        # Remove the empty matched folder
        Dir.rmdir(matched_path)
        
        puts "Completed processing #{matched_path}"
      end
    end
    
    puts "Reorganization complete!"
  end
end

