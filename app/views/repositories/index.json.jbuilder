json.start @start
json.page @page
json.limit @per_page
json.numResults @count
json.results @repositories do |repository|
  json.(repository, :title, :uuid)
  json.uri repository_url(repository)
end
