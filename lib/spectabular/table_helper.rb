module Spectabular
  module TableHelper
    
    def table_for(collection,*columns)
      columns = columns.first if columns.size <= 1
      columns ||= default_columns_for(collection)
      @table = Spectabular::Table.new(  :collection => instance_variable_get("@#{collection}"), 
                                        :collection_name => collection.to_s.humanize, 
                                        :columns => columns, 
                                        :context => self
                                        )
      if @table.empty?
        @table.empty_message
      else
        content_tag(:table, "\n" + [spectabular_header,spectabular_body].join("\n")) + "\n" + spectabular_pagination
      end
    end

    protected

    def spectabular_header
      content_tag(:thead, "\n" +
      content_tag(:tr, "\n" +
        @table.headers.map { |header| 
            content_tag(:th, header)
          }.join("\n") + "\n"
      ) + "\n"
      )
    end

    def spectabular_body
      content_tag(:tbody, "\n" +
      @table.rows.map { |record,row| 
        content_tag(:tr, "\n" + spectabular_row(row), :id => dom_id(record), :class => row_class_for(record) )
      }.join("\n")  + "\n"
      )
    end

    def spectabular_row(row)
      row.map { |name,cell| 
        content_tag :td, cell.to_s, :class => name
      }.join("\n")  + "\n"
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
    
    def default_columns_for(collection)
      returning(OrderedHash.new) do |columns_hash|
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
        attribute
      end
    end

  end
end