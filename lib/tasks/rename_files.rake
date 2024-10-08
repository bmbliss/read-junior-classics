require 'fileutils'

desc "Rename files containing 'anonymous' or 'aesop'"
task :rename_files => :environment do
  Dir.glob('stories/**/*') do |file|
    if File.file?(file)
      dirname = File.dirname(file)
      basename = File.basename(file, '.*')
      extension = File.extname(file)

      if basename.downcase.include?('anonymous') || basename.downcase.include?('aesop')
        new_basename = basename.gsub(' ', '_')
        
        if new_basename.downcase.include?('anonymous')
          new_basename.gsub!(/(_?)anonymous/i, '_by_anonymous')
        elsif new_basename.downcase.include?('aesop')
          new_basename.gsub!(/(_?)aesop/i, '_by_aesop')
        end

        new_filename = File.join(dirname, "#{new_basename}#{extension}")
        
        if file != new_filename
          FileUtils.mv(file, new_filename)
          puts "Renamed: #{file} to #{new_filename}"
        end
      end
    end
  end
end
