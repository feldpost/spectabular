module Spectabular
  module Helper
    
    def table_for(collection,*columns)
      columns = columns.first if columns.size <= 1
      columns ||= default_columns_for(collection)
      @table = Spectabular::Table.new(  :collection => instance_variable_get("@#{collection}"), 
                                        :collection_name => collection.to_s.humanize, 
                                        :columns => columns, 
                                        :context => self
                                        )
      output = []
      if @table.empty?
        output << @table.empty_message.html_safe
      else
        output << content_tag(:table, join_formatted([spectabular_header,spectabular_body]), :class => "spectabular").html_safe
        output << spectabular_pagination.html_safe
      end
      join_formatted output
    end

    protected
    
    def join_formatted(array,join_string="\n")
      join_string.html_safe + safe_join(array, join_string.html_safe ) + join_string.html_safe
    end

    def spectabular_header
      content_tag(:thead, header_row).html_safe
    end
    
    def header_row
      content_tag(:tr, join_formatted(mapped_headers)).html_safe
    end
    
    def mapped_headers
      @table.headers.map do |header| 
          content_tag(:th, header)
      end
    end

    def spectabular_body
      content_tag(:tbody, join_formatted(mapped_body)).html_safe
    end
    
    def mapped_body
      @table.rows.map do |record,row| 
        @column_number = 0
        content_tag(:tr, join_formatted(mapped_row(row)), :id => dom_id(record), :class => row_class_for(record) )
      end
    end

    def mapped_row(row)
      row.map do |name,cell| 
        content_tag :td, cell.to_s.html_safe, :class => cell_class_for(name,@column_number+=1)
      end
    end
    
    def row_class_for(record)
      token = [cycle('odd','even')]
      is_active = [:active?, :is_active?, :published?].find {|m| record.respond_to? m }
      if is_active
        token << (record.send(is_active) ? "active" : 'inactive')
      end
      token.join(" ")
    end
    
    def cell_class_for(name,column_number)
      column_number == 1 ? "tbl-#{name} lead" : name
    end

    def spectabular_pagination
      return "" unless @table.will_paginate?
      content_tag(:p, will_paginate(@table.collection), :class => 'pagination').html_safe
    end
    
    def default_columns_for(collection)
      {}.tap do |columns_hash|
        collection.to_s.classify.constantize.content_columns.map do |c|
          columns_hash[c.name.to_sym] = Proc.new {|a| default_formatting_for(a, c.name, c.type) }
        end
      end
    end
    
    def default_formatting_for(record,name,column_type)
      attribute = record.send(name)
      case column_type
      when :datetime
        attribute.not_blank? ? attribute.strftime("%m/%d/%Y %H:%M:%S") : ""
      when :boolean
        attribute == true ? "Yes" : "No"
      else
        attribute.html_safe
      end
    end

  end
end