require 'nokogiri'
require 'open-uri'
require 'pry'

require "pstore"
def store
  @store ||= PStore.new("data.pstore")
end

figures = store.transaction do
  store["figures"]
end

require "./cache"
require "./figures"

def cached_uri(uri)
  content = store.transaction(true) do
    store[uri]
  end

  return content if content

  content = open(uri).read

  store.transaction do
    store[uri] = content
  end

  return content
end

def date(text)
  Date.parse(text).to_s rescue nil
end

def extract_by_class(doc, selector)
  if (node = doc.css(selector)).length > 0
    node.text
  end
end

def extract_from_table(doc, name)
  if (node = doc.css("tr th:contains(\"#{name}\") ~ td")).length > 0
    node.text
  end
end

def lookup(name)
  uri = "http://en.wikipedia.org/wiki/#{name.gsub(" ", "_")}"
  doc = Nokogiri::HTML(cached_uri(uri))

  bday = date(extract_by_class(doc, ".bday") || extract_from_table(doc, "Born"))
  dday = date(extract_by_class(doc, ".dday") || extract_from_table(doc, "Died"))

  [bday, dday]
end

def presidents
  uri = "http://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States"
  doc = Nokogiri::HTML(cached_uri(uri))

  president_names = doc.xpath("//*[@id=\"mw-content-text\"]/table[1]/tr/td[2]/b/a").map do |item|
    item.text
  end

  president_names
end

unless figures
  figures = (FIGURES + presidents).uniq.sort
  store.transaction do
    store["figures"] = figures
  end
end

# data = figures.map do |name|
#   begin
#     born, died = lookup(name)

#     tuple = [name, born, died]

#     puts tuple

#     tuple
#   rescue
#     nil
#   end
# end.compact

data = get "figures"
puts data

# put "figures", data
