require 'fileutils'

def sanitize_filename(filename)
  filename.gsub(/[^0-9A-Za-z.\-]/, '_').gsub(/_+/, '_').downcase
end

task :aesops_fables do
  # Read the entire file
  content = File.read('stories/volume1/aesops-fables.txt')

  # Split the content into fables
  fables = content.split(/\n\n\n\n/).drop(1) # Drop the first element (introduction)

  # Create a directory for the output files
  FileUtils.mkdir_p('output_fables')

  fables.each do |fable|
    # Extract the title (first line of each fable)
    title = fable.lines.first.strip

    # Clean up the title for use as a filename
    filename = sanitize_filename(title) + '_aesop.txt'

    # Write the fable to a new file
    File.open(File.join('output_fables', filename), 'w') do |file|
      file.write(fable.strip)
    end

    puts "Created: #{filename}"
  end

  puts "Finished processing #{fables.size} fables."
end