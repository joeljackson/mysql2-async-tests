require 'bundler'
require 'mysql2'
require 'mysql2/em'
require 'benchmark'

Thread.new do
  EM.run
end

query = 'select * from users where username = \'doxciqpcaaywtowuu\''
client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'async')
pool = (1..20).to_a.map do Mysql2::Client.new(host: 'localhost', username: 'root', database: 'async') end
em_pool = (1..20).to_a.map do Mysql2::EM::Client.new(host: 'localhost', username: 'root', database: 'async') end

Benchmark.bm(30) do |m|

  m.report('Async:') do
    (0...20).each do |itt|
      pool[itt].query(query, async: true)
    end
  end

  m.report('EM:') do
    (0...20).each do |itt|
      em_pool[itt].query(query)
    end
  end

  m.report('No async:') do
    (1..20).each do
      client.query(query)
    end
  end
end

while true do
  sleep 2
end