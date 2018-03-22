require 'mongo'

class RubyMongodb
  attr_reader :client, :collection

  def initialize(args={})
    host = args['host'] || '127.0.0.1'
    port = args['port'] || '27017'
    database = args['database'] || 'NonamedDB'
    @client = Mongo::Client.new([ [host, port].join(':') ], :database => database)
  end

  def set_collection(coll)
    @collection = @client[coll]
  end

  def insert(obj)
    @collection.insert_one(obj)
  end

  def update(obj)
    @collection.find_one_and_update(obj, { "$set" => obj})
  end

  def insert_or_update(obj)
    existing_obj = @collection.find("name"=>"Wetpaint").limit(1)
    p '---------------------------------------------------------------------------------------------'
     existing_obj.each do |x|
      p x.inspect
    end
    if existing_obj
      @collection.find_one_and_update(obj, { "$set" => obj})
    else
      insert(obj)
    end
  end
end
