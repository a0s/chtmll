class QueryContract < Dry::Validation::Contract
  CommonQueryParams = Dry::Schema.Params do
    optional(:theme_ids).value(array[:integer])
    optional(:category_ids).value(array[:integer])
    optional(:comments).value(array[:string])
  end
end