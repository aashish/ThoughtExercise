
require_relative 'ruby_mongodb'
require_relative 'parser'

def json1
  <<-EOJ
  {
    "1": {
      "url": "url_1",
      "title": "title_1",
      "http_req": {
        "status": 200,
        "time": 10
      }
    },
    "2": {
      "url": "url_2",
      "title": "title_2",
      "http_req": {
        "status": 404,
        "time": -1
      }
    },
    "3": {
      "url": "url_3",
      "title": "title_3",
      "http_req": {
        "status": 200,
        "time": 10
      }
    },
    "4": {
      "url": "url_4",
      "title": "title_4",
      "http_req": {
        "status": 404,
        "time": -1
      }
    },
    "5": {
      "url": "url_5",
      "title": "title_5",
      "http_req": {
        "status": 200,
        "time": 10
      }
    },
    "6": {
      "url": "url_6",
      "title": "title_6",
      "http_req": {
        "status": 404,
        "time": -1
      }
    }

  }
  EOJ
end

def json2
  <<-EOJ
[{
"id": 1,
"awesome_attribute": "awesome attribute value",
"dynamic_attribute": "is lucky to be here"
},
{
"id": 2,
"awesome_attribute": "stellar attribute value",
"tubular_attribute": {
"has_tubes": "Totally",
"which_tubes": [3,5,7,4]
}
}
]
EOJ
end

# initialize Mongodb with collection
db_init = RubyMongodb.new
db_init.set_collection('JsonCollection')


json = File.new('companies.json', 'r')
# io = StringIO.new(json1 )
resource_parser = Parser.new(json, db_init)

start_time = Time.now
puts "Started processing json at: #{start_time}"
count = 0
resource_parser.to_enum.each do |resource|
  count += 1
  #puts "READ: #{count}"
  #p resource
end

#p resource_parser.result
end_time = Time.now

puts "Finished processing json at: #{end_time}"
puts "Processing time: #{(end_time - start_time)/60} minutes" 
