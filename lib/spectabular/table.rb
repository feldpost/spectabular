module Spectabular

  class Table
    attr_accessor :columns, :skip_sorting_row, :collection, :collection_name, :context, :will_paginate
    attr_writer :default_empty

    def initialize(options={})
      options.each do |key,value|
        self.send("#{key}=",value)
      end
    end

    def columns
      @columns.flatten
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
      returning OrderedHash.new do |collection_hash|
        collection.each do |record|
          column_hash = OrderedHash.new
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
          context.send(column[:helper],record)
        elsif column[:value] 
          record.send column[:value]
        else
          nil
        end
      end
    end

    def will_paginate?
      if will_paginate.nil?
        collection_supports_pagination?
      else
        paginate
      end
    end

    def headers
      @headers ||= columns.map do |column|
        if column.respond_to? :to_sym
          column.to_s.humanize
        else
          column[:header].to_s
        end
      end
    end

    def default_empty
      @default_empty || ''
    end

    protected

    def collection_supports_pagination?
      collection.respond_to? :per_page
    end

  end
end