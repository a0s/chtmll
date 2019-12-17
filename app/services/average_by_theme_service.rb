class AverageByThemeService
  include Dry::Transaction(container: Steps::Container)

  step :validate
  map :prepare_query, with: 'steps.prepare_query'
  map :process_theme_ids, with: 'steps.process_theme_ids'
  map :process_category_ids, with: 'steps.process_category_ids'
  map :process_comments, with: 'steps.process_comments'
  map :average_by_theme

  def validate(params)
    result = AggregationQueryContract.new.(params)
    if result.success?
      Success(params)
    else
      Failure(result.errors.to_h)
    end
  end

  def average_by_theme(params)
    unless params[:review_themes_was_joined]
      params[:query] = params[:query].joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
    end
    params[:query].group('rt.theme_id').average('rt.sentiment')
  end
end