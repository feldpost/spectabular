#Spectabular

_Spectabular_ provides a helper method which turns ActiveModel resources into tabular displays. It provides some minimal customization options.


## Installation

In your Rails application, add the following line to your `Gemfile`

```ruby
  gem 'spectabular', :git => 'git://feldpost@github.com/feldpost/spectabular.git'
```

Run `bundle install`.

## Usage

In your controller:

```ruby
@articles = Article.all
```

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
