require 'rubygems'
require 'zip'
require 'digest'
require 'firebase'

# This script updates the md5 hash table

base_uri = 'https://navit-planet.firebaseio.com/'
firebase = Firebase::Client.new(base_uri)

Zip::File.open('planet-150101.bin') do |zip_file|
  zip_file.each do |entry|
    puts "Extracting #{entry.name}"
    # Read into memory
    content = entry.get_input_stream.read
    md5 = Digest::MD5.new
    md5 << content

    response = firebase.set(entry.name, { :hash => md5.hexdigest })
  end
end
