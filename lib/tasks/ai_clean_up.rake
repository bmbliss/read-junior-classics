# take all the combined poems
# use claude's haiku and have it clean up the poems
# save those with the new file names using the first two lines plus the existing number at the end of the original file name
# 
# could I use ollama on my machine?
# 

require 'net/http'
require 'json'
require 'fileutils'

task :ai_clean_up do
  content = File.read('volumes/volume10.txt')
  cleaned_content = ""

  # split up the content into 200 line chunks
  chunks = content.split("\n").each_slice(100).to_a

  # shorten this to the first 10 chunks for testing
  chunks = chunks.first(10)

  chunks.each_with_index do |chunk, index|
    puts "Processing chunk #{index + 1} of #{chunks.length}"
    corrected_poem = correct_chunk(chunk.join("\n"))
    cleaned_content << "#{corrected_poem}\n"
  end
  
  File.write('volumes/volume10-clean.txt', cleaned_content)
end

def correct_chunk(poem)
  retries = 0

  begin
    uri = URI('http://localhost:11434/api/generate')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = {
      model: 'llama3.2',
      prompt: "This chunk of text belongs to one or more poems and may contain some typos or syntax errors. Please rewrite it and correct any typos, punctuation, line breaks, capitalization, formatting, spelling, etc\n\nChunk:\n#{poem}\n\nPlease return it in this format and nothing else:\n\n<chunk>\nexample chunk\n</chunk>",
      stream: false
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)

      new_chunk = result['response']
      # puts new_chunk
      # extracted_poem = result['response'].match(/<chunk>(.*?)<\/chunk>/m)&.[](1)
      
      # raise "failed to parse" unless extracted_poem

      # extracted_poem.strip
      new_chunk
    else
      raise "non 200 resposne"
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
