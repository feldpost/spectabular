module Spectabular

  class Table
    attr_accessor :columns, :skip_sorting_row, :collection, :collection_name, :context
    attr_writer :default_empty

    def initialize(options={})
      options.each do |key,value|
        self.send("#{key}=",value)
      end
    end

    def columns
      case @columns
       when Array
          @columns.flatten
        when Hash
          sorted_hash_for(@columns).map {|g| {:header => header_for(g[0]), :helper => g[1]}}
      else
        [@columns]
      end
    end

    def empty?
      collection.blank?
    end
    
    def default_empty
      @default_empty ||= 'n/a'
    end

    def empty_message
      "No #{collection_name} added yet"
    end

    def rows
      ordered_hash.tap do |collection_hash|
        collection.each do |record|
          column_hash = ordered_hash
            columns.each_with_index do |column,i|
              column_hash[headers[i].parameterize] = cell(column,record) || default_empty
            end
          collection_hash[record] = column_hash
        end
      end
    end

    def cell(column,record)
      if column.respond_to? :to_sym
        record.send column.to_sym
      else
        if column[:helper]
         column[:helper].respond_to?(:call) ? column[:helper].call(record) : context.send(column[:helper],record)
        elsif column[:value] 
          record.send column[:value]
        else
          nil
        end
      end
    end

    def headers
      @headers ||= columns.map do |column|
        if column.respond_to? :to_sym
          column.to_s.humanize
        else
          column[:header].is_a?(Symbol) ? column[:header].to_s.humanize : column[:header].to_s
        end
      end
    end

    def default_empty
      @default_empty || ''
    end

    protected
    
    def ordered_hash(*args)
      if RUBY_VERSION < '1.9'
        Hash.new(*args)
      else
        OrderedHash.new(*args)
      end
    end
    
    def sorted_hash_for(items)
      if RUBY_VERSION < '1.9'
        items.sort {|a,b| a[0].to_s <=> b[0].to_s }
      else
        items
      end
    end
    
    def header_for(name)
      if name.respond_to?(:sub)
        name.sub(/^\d+\s?-\s?/,'')
      else
        name.to_s.titlecase
      end
    end

  end
end