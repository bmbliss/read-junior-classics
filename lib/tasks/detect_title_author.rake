# take all the combined poems
# use claude's haiku and have it clean up the poems
# save those with the new file names using the first two lines plus the existing number at the end of the original file name
# 
# could I use ollama on my machine?
# 

require 'net/http'
require 'json'
require 'fileutils'

task :detect_title_author do
  content = File.read('volumes/volume10.txt')
  cleaned_content = ""

  # split up the content into 200 line chunks
  chunks = content.split("\n").each_slice(100).to_a

  # shorten this to the first 10 chunks for testing
  chunks = chunks.first(3)

  chunks.each_with_index do |chunk, index|
    puts "Processing chunk #{index + 1} of #{chunks.length}"
    puts chunk.join("\n")
    # corrected_poem = detect_author_title(chunk.join("\n"))
    # cleaned_content << "#{corrected_poem}\n"
  end
  
  File.write('volumes/volume10-clean.txt', cleaned_content)
end

def detect_author_title(chunk)
  retries = 0

  begin
    uri = URI('http://localhost:11434/api/generate')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = {
      model: 'llama3.2',
      prompt: llm_prompt(chunk),
      stream: false
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)

      new_chunk = result['response']
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
      "<error>#{chunk}</error>"
    end
  end
end

def llm_prompt(chunk)
  "This chunk of text belongs to a book of poems. Please determine if the chunk contains the title and author (maybe 'anonymous'), if it does, wrap it in a tag like so:
  <title>SOME TITLE</title>
  <author>By Joe Schmo</author>

  correct any typos, punctuation, etc.
  
  Chunk: 
  #{chunk}
  
  Please return it in this format and nothing else:
  <chunk>
    <title>SOME TITLE</title>
    <author>By Joe Schmo</author>
    this is an example text
    of a poem in this book
  </chunk>
  "
end
