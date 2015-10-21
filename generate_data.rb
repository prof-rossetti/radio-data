# generate_data.rb

require 'pp'
require 'faker'
require 'pry'
require 'csv'
require 'active_support/core_ext/date_time'

def data_path
  File.expand_path("../data", __FILE__)
end

def songs_path
  File.join(data_path, "songs.csv")
end

def listeners_path
  File.join(data_path, "listeners.csv")
end

def listener_accounts_path
  File.join(data_path, "listener_accounts.csv")
end

def plays_path
  File.join(data_path, "plays.csv")
end
def song_headers
  "id, title, artist_name, duration_milliseconds, year_recorded" # songs.first.keys.map{|k| k.to_s}
end

def listener_headers
  "id, full_name, email_address"
end

def listener_account_headers
  "listener_id, cc_holder_name, cc_number, cc_exp_month, cc_exp_year, cc_zipcode, invoice_usd_per_day"
end

def play_headers
  "id, song_id, listener_id, started_playing_at, radio_station_id"
end

def song_count
  250
end

def listener_count
  80
end

def play_count
  80
end

def song_ids
  (1..song_count).to_a
end

def listener_ids
  (1..listener_count).to_a
end

def play_times
  earliest_played_at = DateTime.now - 100 # ... days ago
  latest_played_at = DateTime.now - 2 # ... days ago
  play_times = []
  play_count.times do
    play_times << Faker::Time.between(earliest_played_at, latest_played_at)
  end
  play_times.sort
end

def write_songs_to_file
  puts "OVERWRITING SONGS FILE -- #{songs_path}"
  FileUtils.rm_f(songs_path)
  CSV.open(songs_path, "w", :write_headers=> true, :headers => song_headers) do |csv|
    song_count.times do |n|
      next if n == 0
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

def write_listeners_to_file
  puts "OVERWRITING LISTENERS FILE -- #{listeners_path}"
  FileUtils.rm_f(listeners_path)
  listeners = []
  CSV.open(listeners_path, "w", :write_headers=> true, :headers => listener_headers) do |csv|
    listener_count.times do |n|
      next if n == 0
      real_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      full_name = (rand < 0.3 ? full_name : Faker::Internet.user_name(full_name))
      listener = {
        :id => n,
        :full_name => full_name,
        :email_address => Faker::Internet.free_email(full_name),
        :real_name => real_name
      }
      pp listener
      csv << listener.except(:real_name).values
      listeners << listener # including real_name ...
    end

    write_listener_accounts_to_file(listeners)
  end
end

def write_listener_accounts_to_file(listeners)
  puts "OVERWRITING LISTENER ACCOUNTS FILE -- #{listener_accounts_path}"
  FileUtils.rm_f(listener_accounts_path)
  CSV.open(listener_accounts_path, "w", :write_headers=> true, :headers => listener_account_headers) do |csv|
    listeners.each do |listener|
      listener_account = {
        :listener_id => listener[:id],
        :cc_holder_name => (rand < 0.8 ? listener[:real_name] : Faker::App.author), #(rand < 0.8 ? listener[:real_name] : Faker::Book.author),
        :cc_number => Faker::Business.credit_card_number,
        :cc_exp_month => (1..12).to_a.sample,
        :cc_exp_year => (1..12).to_a.sample,
        :cc_zipcode => Faker::Address.zip_code,
        :invoice_usd_per_day => [0.00, 0.20, 0.40].sample
      }
      pp listener_account
      csv << listener_account.values
    end
  end
end

def write_plays_to_file
  puts "OVERWRITING PLAYS FILE -- #{plays_path}"
  FileUtils.rm_f(plays_path)
  plays = []
  CSV.open(plays_path, "w", :write_headers=> true, :headers => play_headers) do |csv|
    play_times.each_with_index do |play_time, play_id|
      next if play_id == 0
      play = {
        :id => play_id,
        :song_id => song_ids.sample,
        :listener_id => listener_ids.sample,
        :started_playing_at => play_time.to_s(:db), # .is_a?(ActiveSupport::TimeWithZone) ? v.to_s(:db) : v
        :radio_station_id => (rand < 0.3 ? (1..10009).to_a.sample : nil)
      }
      pp play
      csv << play.values
      plays << play
    end
  end

  # CREATE SKIPS AND THUMBS

  skips = []
  thumbs = []
  plays.each do |play|
    pp play
    # either do nothing or thumb or skip
  end

  #puts "OVERWRITING SKIPS FILE -- #{skips_path}"
  #FileUtils.rm_f(skips_path)
  #CSV.open(skips_path, "w", :write_headers=> true, :headers => skip_headers) do |csv|
  #  skips.each do |skip|
  #    #csv << skip.values
  #  end
  #end
#
  #puts "OVERWRITING THUMBS FILE -- #{thumbs_path}"
  #FileUtils.rm_f(thumbs_path)
  #CSV.open(thumbs_path, "w", :write_headers=> true, :headers => thumb_headers) do |csv|
  #  thumbs.each do |thumb|
  #    #csv << thumb.values
  #  end
  #end
end

def generate_data
  #write_songs_to_file
  #write_listeners_to_file
  write_plays_to_file
end

generate_data
