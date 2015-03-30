require 'rubygems'
require 'zip'
require 'digest'
require 'firebase'

base_uri = ''
firebase = Firebase::Client.new(base_uri)
Zip.continue_on_exists_proc = true
Zip::File.open('small.bin') do |zip_file|
  zip_file.each do |entry|
    # Read into memory
    puts "Extracting #{entry.name}"
    content = entry.get_input_stream.read
    md5 = Digest::MD5.new
    md5 << content
    response = firebase.get(entry.name)
    if response.raw_body != 'null'
            hash=response.body['hash']
            if md5.hexdigest == hash
                puts "OK!"
            else
                puts "Update needed! I was expecting #{hash} but got #{md5.hexdigest}"
                new=open("http://webserver:4567/get/#{entry.name}").read
                n_md5 = Digest::MD5.new
                n_md5 << new
                puts "Got #{n_md5.hexdigest}"
                zip_file.get_output_stream(entry.name) { |f| f.print new }
            end
    end
  end
end
