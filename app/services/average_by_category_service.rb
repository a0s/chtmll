class AverageByCategoryService
  include Dry::Transaction(container: Steps::Container)

  step :validate
  map :prepare_query, with: 'steps.prepare_query'
  map :process_theme_ids, with: 'steps.process_theme_ids'
  map :process_category_ids, with: 'steps.process_category_ids'
  map :process_comments, with: 'steps.process_comments'
  map :average_by_category


  def validate(params)
    result = AggregationQueryContract.new.(params)
    if result.success?
      Success(params)
    else
      Failure(result.errors.to_h)
    end
  end

  def average_by_category(params)
    unless params[:review_themes_was_joined]
      params[:query] = params[:query].joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
    end
    unless params[:themes_was_joined]
      params[:query] = params[:query].joins('INNER JOIN themes AS th ON th.id = rt.theme_id')
    end
    params[:query].group('th.category_id').average('rt.sentiment')
  end
end