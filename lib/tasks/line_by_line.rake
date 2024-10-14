require 'net/http'
require 'json'
require 'fileutils'

task :line_by_line do
  content = File.read('volumes/volume10.txt')
  poems = []

  # split up the content into separate lines
  lines = content.split("\n")

  curr_poem = []
  lines.each_with_index do |line, index|
    next if skip_line?(line)
    
    # if this line is the author
    if line.downcase == "anonymous" || (line.include?("By") && author?(line))
      # start a new poem
      poems << curr_poem
      curr_poem = [line]

      # go back to previous poem and grab the title from the last line
      if poems.last
        title = []
        while !poems.last.empty? && poems.last.last.upcase == poems.last.last
          title.unshift(poems.last.pop)
        end
        curr_poem.unshift(*title)
      end
    else
      curr_poem << line
    end
  end

  # add the last poem
  poems << curr_poem

  # loop over the poems and save to their own files
  poems.each_with_index do |poem, index|
    File.write("poems_line_by_line/#{index + 1}.txt", poem.join("\n"))
  end
end

def skip_line?(line)
  # empty, asterisk, number, or single uppercase letter
  line.strip.empty? || line.strip.start_with?("*") || line.strip =~ /^\d+$/ || (line.strip.length == 1 && line.strip.upcase == line.strip)
end

def author?(line)
  authors_list.include?(line.strip.sub("By", "").strip)
end

# def author?(line)
#   retries = 0
  
#   name = line.split("By")[1].strip
#   puts "author? #{name}"

#   begin
#     uri = URI('http://localhost:11434/api/generate')
#     request = Net::HTTP::Post.new(uri)
#     request.content_type = 'application/json'
#     request.body = {
#       model: 'llama3.2',
#       prompt: "indicate only true or false if the following sentence contains the name of a person: \"#{name}\"",
#       stream: false,
#       options: {
#         temperature: 0
#       }
#     }.to_json

#     response = Net::HTTP.start(uri.hostname, uri.port) do |http|
#       http.request(request)
#     end

#     if response.is_a?(Net::HTTPSuccess)
#       result = JSON.parse(response.body)

#       author = result['response']
#       author.downcase.include?("true")
#     else
#       raise "non 200 resposne"
#     end
#   rescue StandardError => e
#     retries += 1
#     if retries < 5
#       puts "failure! retrying..."
#       retry  
#     else
#       puts "tried 5 times, moving on..."
#       false
#     end
#   end
# end

def authors_list
  [
    "Jane Taylor",
    "Josephine Daskam Bacon",
    "George Cooper",
    "Richard Le Gallienne",
    "Eugene Field",
    "Mary Howitt",
    "Robert Louis Stevenson",
    "Sir Walter Scott",
    "Alfred Tennyson",
    "Kate Douglas Wiggin",
    "Anna Maria Pratt",
    "Henry W. Longfellow",
    "William Miller",
    "Charles Mackay",
    "Thomas Bailey Aldrich",
    "L. Maria Child",
    "Susan Coolidge",
    "William Allingham",
    "Theodore Tilton",
    "Algernon Charles Swinburne",
    "Jonathan Swift",
    "Tudor Jenks",
    "Phœbe Cary",
    "Thomas Carlyle",
    "Charles Kingsley",
    "Phillips Brooks",
    "Michael Field",
    "Edward Lear",
    "Clement C. Moore",
    "J. H. Hopkins",
    "Lewis Carroll",
    "Dinah Maria Mulock",
    "William Cowper",
    "James Whitcomb Riley",
    "Anna B. Warner",
    "William Cullen Bryant",
    "Charles Dibdin",
    "James Beattie",
    "James Gates Percival",
    "Sarah J. Day",
    "Robert Browning",
    "Burges Johnson",
    "Thomas Gray",
    "Lucy Larcom",
    "Susan Hartley Swett",
    "Emily Huntington Miller",
    "Mrs. Southey",
    "Leigh Hunt",
    "Charles Lamb",
    "John Keats",
    "Mary F. Butts",
    "William Wordsworth",
    "Edmund Clarence Stedman",
    "Christina G. Rossetti",
    "Nora Hopper",
    "George MacDonald",
    "G. W. Pettee",
    "Jean Ingelow",
    "H. C. Bunner",
    "Dr. Edward Jenner",
    "James Hogg",
    "J. T. Trowbridge",
    "Jeffreys Taylor",
    "John Greenleaf Whittier",
    "Lydia Maria Child",
    "Elizabeth Barrett Browning",
    "H. C. Beeching",
    "Katherine Tynan Hinkson",
    "George Pope Morris",
    "Hannah Flagg Gould",
    "Edwin Arnold",
    "Saxe Holm",
    "Paul H. Hayne",
    "Percy",
    "Lord Byron",
    "H. F. Chorley",
    "Henry Wadsworth Longfellow",
    "Edward Fitzgerald",
    "Sydney Dobell",
    "William Blake",
    "Allan Cunningham",
    "William Motherwell",
    "Helen B. Bostwick",
    "Thomas Lowell Beddoes",
    "Oliver Wendell Holmes",
    "John Howard Payne",
    "Thomas Campbell",
    "Washington Allston",
    "John Dryden",
    "Robert Herrick",
    "Henry Van Dyke",
    "William Shakespeare",
    "Barry Cornwall",
    "Emily Dickinson",
    "Edward Rowland Sill",
    "Denis MacCarthy",
    "James Russell Lowell",
    "John Vance Cheney",
    "Ben Jonson",
    "Isaac Watts",
    "Robert Burns",
    "Robert Southwell",
    "John Milton",
    "Abraham Lincoln",
    "S. F. Smith",
    "Francis Scott Key",
    "Daniel Decatur Emmett",
    "James Thomson",
    "Max Schneckenburger",
    "Rougetde Lisle",
    "Julia Ward Howe",
    "Henry Holcomb Bennett",
    "John Pierpont",
    "Thomas Buchanan Read",
    "Felicia Dorothea Hemans",
    "R. W. Emerson",
    "Walt Whitman",
    "Emma Powell McCulloch",
    "R. W. Gilder",
    "Thomas Babington Macaulay",
    "Arthur Conan Doyle",
    "Bret Harte",
    "Joseph Addison",
    "Sir Henry Wotton",
    "Ralph Waldo Emerson",
    "Paul Laurence Dunbar",
    "William Howitt",
    "William E. Aytoun",
    "Robert Southey",
    "Robert and Caroline Southey",
    "Caroline E. Norton",
    "Samuel Woodworth",
    "Oliver Goldsmith",
    "Samuel Taylor Coleridge",
    "Edgar Allan Poe"
  ]
end
