json.start @start
json.limit @limit
json.numResults @count
json.results @collections do |col|
  json.title col.title
  json.id col.repository_id
  json.uri collection_url(col)
end
