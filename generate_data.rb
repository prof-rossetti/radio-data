# generate_data.rb

require 'pp'
require 'faker'
require 'pry'
require 'csv'

def data_path
  File.expand_path("../data", __FILE__)
end

def songs_path
  File.join(data_path, "songs.csv")
end

def song_headers
  "id, title, artist_name, duration_milliseconds, year_recorded" # songs.first.keys.map{|k| k.to_s}
end

def write_to_file
  puts "OVERWRITING SONGS FILE -- #{songs_path}"
  FileUtils.rm_f(songs_path)
  CSV.open(songs_path, "w", :write_headers=> true, :headers => song_headers) do |csv|
    250.times do |n|
      song = {
        :id => n,
        :title => Faker::Book.title, # (rand < 0.5 ? Faker::App.name : Faker::Book.title),
        :artist_name => Faker::App.author, # (rand < 0.5 ? Faker::App.author : Faker::Book.author), # "#{Faker::Name.first_name} #{Faker::Name.last_name}",
        :duration_milliseconds => (120000..480000).to_a.sample,
        :year_recorded => ((Date.today.year - 75)..Date.today.year).to_a.sample
      }
      pp song
      csv << song.values
    end
  end
end

def generate_data
  write_to_file
end

generate_data

=begin
  :responded_at => Faker::Time.between(DateTime.now - 10, DateTime.now - 2),
  :email => Faker::Internet.free_email(full_name),
  :nickname => (rand < 0.26 ? Faker::App.name : nil),
  :date_of_birth => Faker::Date.between(Date.today.year - 15, Date.today.year - 18),
  :university => Faker::University.name,
  :graduation_class => ["Freshman","Sophomore","Junior","Senior","Graduate","Alumni"].sample,
  :hometown => "#{Faker::Address.city}, #{Faker::Address.country}",
  :majors => (rand < 0.67 ? ["Engineering","Information Systems"].sample : ["Other","Marketing","Finance"].sample),
  :scheduling => (rand < 0.1 ? (rand < 0.5 ? "conflict_before" : "conflict_after") : nil),
  :interests =>  Faker::Lorem.paragraph,
  :interest_adventure =>  (rand < 0.75 ? 1 : 0),
  :operating_system => (rand < 0.95 ? ["Mac OS","Windows OS"].sample : "Other"),
  :operating_system_usage_windows => (rand < 0.85 ? 1 : 0),
  :website_experience => (rand < 0.7 ? 1 : 0),
  :meetup_comfort => (rand < 0.4 ? "Sounds fine" : "Sounds scary")
=end
