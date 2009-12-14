module Spectabular
  module TableHelper

    def table_for_collection(*args,&block)
      options = args.extract_options!
      options = spectabular_options(options)      
      options.reverse_merge!({:columns => args, :context => self})
      @table = Spectabular::Table.new(options)
      if @table.empty?
        @table.empty_message
      else
        content_tag(:table, spectabular_header + spectabular_body) + spectabular_pagination
      end
    end

    protected

    def spectabular_header
      content_tag(:thead,
      content_tag(:tr,
        @table.headers.map { |header| 
            content_tag(:th, header) 
          }.join
      )
      )
    end

    def spectabular_body
      content_tag(:tbody, 
      @table.rows.map { |record,row| 
        content_tag(:tr, spectabular_row(row), :id => dom_id(record), :class => row_class_for(record) )
      }.join
      )
    end

    def spectabular_row(row)
      row.map { |name,cell| 
        content_tag :td, cell, :class => name
      }.join
    end
    
    def row_class_for(record)
      token = [cycle('odd','even')]
      is_active = [:active?, :is_active?, :published?].find {|m| record.respond_to? m }
      if is_active
        token << (record.send(is_active) ? "active" : 'inactive')
      end
      token.join(" ")
    end

    def spectabular_pagination
      return "" unless @table.will_paginate?
      content_tag(:p, will_paginate(@table.collection), :class => 'pagination')
    end

    def spectabular_options(options)
      if options[:collection].blank?
        collection = instance_variable_get("@#{controller.controller_name}")
        collection_name = controller.controller_name.humanize
      else
        collection = instance_variable_get("@#{options[:collection]}")
        collection_name = options[:collection].to_s.humanize
      end
      options.merge!({:collection => collection, :collection_name => collection_name})
    end

  end
end