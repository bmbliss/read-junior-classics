require 'rake'
require 'fileutils'

task :combine_poems do
  pages = []

  Dir.glob('extracted_poems/**/*') do |file|
    if File.file?(file)
      file_name = file.split('/').second
      pages << {
        page: file_name.split('_').last.split('.').first.to_i,
        title: file_name.split('_').first,
        author: file_name.split('_').second,
        original_file_name: file,
        file_name:,
      }
    end
  end

  # puts pages.map { |page| page[:title] }.join(', ')

  # sort pages by page number
  pages.sort_by! { |page| page[:page] }

  curr_title = pages.first[:title]
  combined_pages = []
  combined_index = 0
  pages.each_with_index do |page, index|
    if String::Similarity.cosine(curr_title.downcase, page[:title].downcase) > 0.9
      if combined_pages[combined_index].nil?
        combined_pages[combined_index] = [page]
      else
        combined_pages[combined_index] << page
      end
    else
      curr_title = page[:title]
      combined_index += 1
      combined_pages[combined_index] = [page]
    end
  end

  combined_pages.each do |combined_page|
    puts combined_page
    # attempt to find a title with an author
    title_with_author = combined_page.find { |page| page[:file_name].downcase.include?("_by") }
    
    # otherwise, just use the first one
    new_file_name = title_with_author ? title_with_author[:file_name] : combined_page.first[:file_name]

    combined_content = combined_page.map { |page| File.read(page[:original_file_name]) }.join("\n\n")

    File.open(File.join('combined_poems', new_file_name), 'w') do |file|
      file.puts combined_content
    end
  end
end

