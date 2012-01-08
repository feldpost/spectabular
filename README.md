#Spectabular

_Spectabular_ provides a helper method which turns ActiveModel resources into tabular displays. It provides some minimal customization options.

## Compatibility

_Spectabular_ 2 is only compatible with Rails 3.0 and above. It has been tested on Rails 3.1 and 3.2.

If you are using Rails 2, please use _Spectabular_ 1 (*Rails-2* branch).

## Installation

In your Rails application, add the following line to your `Gemfile`

```ruby
  gem 'spectabular', :git => 'git://feldpost@github.com/feldpost/spectabular.git'
```

Run `bundle install`.

## Usage

Assuming you have this in your controller:

```ruby
@articles = Article.all
```

In your views:

### Default:

```ruby
  table_for :articles
```

Generates table with all content columns.

### Specify columns to use:

```ruby
  table_for :articles, :title, :description
```

Only shows the _title_ and _description_ attributes.


### Specify column headers and content to use:

```ruby
  table_for :articles,
            "Title" => :helper_method,
            "Description" => Proc.new {|record| record.description }
```

You can specify a helper method or block to be called. Both block and helper method take one argument, the record being passed to the table row.

#### Note for Ruby 1.8

Because Hashes in Ruby 1.8 are not ordered, in the above example the column order is not guaranteed. Thus, you can number your columns as such:

```ruby
  table_for :articles,
            "1-Title" => :helper_method,
            "2-Description" => Proc.new {|record| record.description }
```

The numeration markers are removed and column order is maintained. This is not necessary if you are using Ruby 1.9.
