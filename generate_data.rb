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

def listeners_path
  File.join(data_path, "listeners.csv")
end

def listener_accounts_path
  File.join(data_path, "listener_accounts.csv")
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

def write_songs_to_file
  puts "OVERWRITING SONGS FILE -- #{songs_path}"
  FileUtils.rm_f(songs_path)
  CSV.open(songs_path, "w", :write_headers=> true, :headers => song_headers) do |csv|
    250.times do |n|
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
    80.times do |n|
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

def generate_data
  write_songs_to_file
  write_listeners_to_file
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
