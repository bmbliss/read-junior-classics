require 'csv'
require 'fileutils'

VOLUME_TITLES = {
  1 => "Fairy and Wonder Tales",
  2 => "Folk Tales and Myths",
  3 => "Tales From Greece and Rome",
  4 => "Heroes and Heroines of Chivalry",
  5 => "Stories That Never Grow Old",
  6 => "Old-Fashioned Tales",
  7 => "Stories of Courage and Heroism",
  8 => "Animal and Nature Stories",
  9 => "Stories of To-Day",
  10 => "Poems Old and New"
}

def roman_to_integer(roman)
  roman_values = {
    'I' => 1, 'V' => 5, 'X' => 10, 'L' => 50,
    'C' => 100, 'D' => 500, 'M' => 1000
  }
  
  result = 0
  previous_value = 0

  roman.reverse.each_char do |char|
    current_value = roman_values[char]
    
    # Add guard clause to handle nil values
    if current_value.nil?
      raise ArgumentError, "Invalid Roman numeral character: #{char}"
    end

    if current_value >= previous_value
      result += current_value
    else
      result -= current_value
    end
    
    previous_value = current_value
  end

  result
end

def determine_work_type(volume)
  case volume
  when 1
    :fairy_tale
  when 2
    :folk_tale # This could be either folktale or myth, we might need to differentiate
  when 3
    :myth # Assuming tales from Greece and Rome are mostly myths
  when 4
    :legend # Heroes and heroines of chivalry are often legendary figures
  when 5, 6, 7, 8, 9
    :story # General stories
  when 10
    :poem
  else
    :other
  end
end

namespace :import do
  desc 'Import Junior Classics data from CSV'
  task junior_classics: :environment do
    csv_file = Rails.root.join('junior_classics.csv')
    
    programs = {}
    
    CSV.foreach(csv_file, headers: true) do |row|
      volume = roman_to_integer(row['volume'].strip)
      title = row['title'].strip
      author = (row['author'].presence || 'Unknown').strip

      literary_work = LiteraryWork.create!(
        title: title,
        author: author,
        volume: volume,
        page: row['page'].strip.to_i,
        work_type: determine_work_type(volume),
      )
      
      collection_name = "Junior Classics Volume #{volume}: #{VOLUME_TITLES[volume]}"
      collection = Collection.find_or_create_by!(name: collection_name)
      collection.literary_works << literary_work
      
      grade = row['grade'].strip
      grade_num = roman_to_integer(grade.split(' ').last)
      programs[grade] ||= Program.find_or_create_by!(name: "Junior Classics - #{grade}", recommended_grade: grade_num)
      
      ProgramItem.create!(
        program: programs[grade],
        literary_work: literary_work
      )
    end
    
    puts "Imported #{LiteraryWork.count} literary works into #{Collection.count} collections."
    puts "Created #{Program.count} programs with #{ProgramItem.count} program items for the Junior Classics Reading Program."
  end
end
