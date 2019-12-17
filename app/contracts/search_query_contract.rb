class SearchQueryContract < QueryContract
  params(CommonQueryParams) do
    optional(:limit).value(:integer)
  end
end