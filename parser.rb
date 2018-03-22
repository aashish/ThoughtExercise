require 'json/stream'
class Parser
  METHODS = %w[start_document end_document start_object end_object start_array end_array key value].freeze

  attr_reader :result, :parser

  def initialize(io, db = nil, chunk_size = 1024)
    @io = io
    @db = db
    @chunk_size = chunk_size
    @parser = JSON::Stream::Parser.new

    # register callback methods
    METHODS.each do |name|
      @parser.send(name, &method(name))
    end
  end

  def to_enum
    Enumerator.new do |yielder|
      @yielder = yielder
      begin
        until @io.eof?
          # puts "READING CHUNK"
          chunk = @io.read(@chunk_size)
          @parser << chunk
        end
      ensure
        @yielder = nil
      end
    end
  end

  def start_document
    @stack = []
    @result = nil
  end

  def end_document
    # @result = @stack.pop.obj
  end

  def start_object
    if @stack.empty?
      @stack.push(ResourceCollectionNode.new)
    elsif @stack.size == 1
      @stack.push(ResourceNode.new)
    else
      @stack.push(ObjectNode.new)
    end
  end

  def end_object
    if @stack.size == 2
      node = @stack.pop
      # puts "Stack depth: #{@stack.size}. Node: #{node.class}"
      @stack[-1] << node.obj

      # insert record to db

      @db.insert(node.obj)

      # puts "Parsed complete resource: #{node.obj}"
      @yielder << node.obj

    elsif @stack.size == 1
      # puts "Parsed all resources"
      @result = @stack.pop.obj
    else
      node = @stack.pop
      # puts "Stack depth: #{@stack.size}. Node: #{node.class}"
      @stack[-1] << node.obj
    end
  end

  def end_array
    node = @stack.pop
    # puts "Stack pop: #{node}, obj: #{node.obj}"

    if @stack.empty?
      @result = node.obj
    else
      @stack[-1] << node.obj
    end
  end

  def start_array
    @stack.push(ArrayNode.new)
  end

  def key(key)
    # puts "Stack depth: #{@stack.size} KEY: #{key}"
    @stack[-1] << key
  end

  def value(value)
    node = @stack[-1]
    node << value
  end

  class ObjectNode
    attr_reader :obj

    def initialize
      @obj = {}
      @key = nil
    end

    def <<(node)
      if @key
        @obj[@key] = node
        @key = nil
      else
        @key = node
      end
      self
    end
  end

  class ResourceNode < ObjectNode
  end

  # Node that contains all the resources - a Hash keyed by url
  class ResourceCollectionNode < ObjectNode
    def <<(node)
      if @key
        @obj[@key] = node
        # puts "Completed Resource: #{@key} => #{node}"
        @key = nil
      else
        @key = node
      end
      self
    end
  end

  class ArrayNode
    attr_reader :obj

    def initialize
      @obj = []
    end

    def <<(node)
      @obj << node
      self
    end
  end
end
