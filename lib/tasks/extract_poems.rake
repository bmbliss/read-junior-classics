require 'rake'
require 'fileutils'

task :extract_poems do
  file_path = "volumes/volume10.txt"
  content = File.read(file_path)
  sections = content.split(/(?=^[A-Z\s]+$)/m)
  
  # strip out the blank lines
  stripped_sections = sections.map { |section| section.strip }

  # remove any empty lines
  stripped_sections = stripped_sections.reject(&:empty?)

  combined_sections = []
  current_item = ""

  stripped_sections.each do |section|
    if section.upcase == section
      # This section is all caps (potential title/header)
      current_item += section
    else
      # This section contains content
      combined_sections << (current_item + section)
      current_item = ""
    end
  end

  # Add any remaining item
  combined_sections << current_item if current_item != ""

  # save these combined sections to their own files
  combined_sections.each_with_index do |section, index|
    File.open(File.join('extracted_poems', "#{section.split("\n").first}_#{section.split("\n").second}_#{index}.txt"), 'w') do |file|
      file.puts section
    end
  end
end

