require 'spectabular'

if defined?(ActionView)
  require 'spectabular/helper'
  ActionView::Base.class_eval do
    include Spectabular::Helper
  end
end