require 'bundler'
Bundler.require(:default)

client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'async')

(1..100000).each do |num|
  string_creator = ->(length) do (1..length).map do ('a'..'z').to_a[rand(32)] end.join end
  
  username = string_creator.call(20)
  password = string_creator.call(20)
  email    = string_creator.call(20)

  client.query("insert into users values(#{num}, \"#{username}\", \"#{password}\", \"#{email}\");")
end

