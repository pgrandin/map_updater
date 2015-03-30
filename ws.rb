require 'rubygems'
require 'zip'
require 'digest'
#require 'firebase'
require 'sinatra'


get '/get/:name' do
        Zip::File.open('california-latest.bin') do |zip_file|
                entry = zip_file.glob(params[:name]).first
                content=entry.get_input_stream.read
                md5 = Digest::MD5.new
                md5 << content
                puts "Expected md5 : ", md5.hexdigest
                content
        end
end
