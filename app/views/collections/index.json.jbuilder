json.start @start
json.page @page
json.limit @per_page
json.numResults @count
json.results @collections do |col|
  json.title col.title
  json.id col.uuid
  json.uri collection_url(col)
end
