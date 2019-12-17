class SearchReviewService
  include Dry::Transaction(container: Steps::Container)

  step :validate
  map :prepare_query, with: 'steps.prepare_query'
  map :process_theme_ids, with: 'steps.process_theme_ids'
  map :process_category_ids, with: 'steps.process_category_ids'
  map :process_comments, with: 'steps.process_comments'
  map :search

  def validate(params)
    result = SearchQueryContract.new.(params)
    if result.success?
      Success(params)
    else
      Failure(result.errors.to_h)
    end
  end

  def search(params)
    params[:query].distinct(:id).limit(params[:limit]).all
  end
end
