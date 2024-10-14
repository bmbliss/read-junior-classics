# take all the combined poems
# use claude's haiku and have it clean up the poems
# save those with the new file names using the first two lines plus the existing number at the end of the original file name
# 
# could I use ollama on my machine?
# 

require 'net/http'
require 'json'
require 'fileutils'

task :ai_poems do
  FileUtils.mkdir_p('ai_poems') # Ensure the output directory exists

  Dir.glob('combined_poems/**/*') do |file|
    if File.file?(file)
      original_poem = File.read(file)
      corrected_poem = correct_poem(original_poem)
      
      # Create the new file path
      new_file_path = file.gsub('combined_poems', 'ai_poems')
      FileUtils.mkdir_p(File.dirname(new_file_path))
      
      File.write(new_file_path, corrected_poem)
      puts "Processed: #{file} -> #{new_file_path}"
    end
  end
end

def correct_poem(poem)
  retries = 0

  begin
    uri = URI('http://localhost:11434/api/generate')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = {
      model: 'llama3.2',
      prompt: "This poem may contain some typos or syntax errors. Please rewrite it and correct any typos, punctuation, line breaks, capitalization, formatting, spelling, etc\n\nPoem:\n#{poem}\n\nPlease return it in this format and nothing else:\n\n<poem>\nexample poem\n</poem>",
      stream: false
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      extracted_poem = result['response'].match(/<poem>(.*?)<\/poem>/m)&.[](1)

      raise "failed to parse response" unless extracted_poem

      extracted_poem.strip
    else
      raise "non 200 response"
    end
  rescue StandardError => e
    retries += 1
    if retries < 5
      puts "failure! retrying..."
      retry  
    else
      puts "tried 5 times, moving on..."
      "<error>#{poem}</error>"
    end
  end
end
