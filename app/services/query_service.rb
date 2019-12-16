class QueryService
  QueryBuilderParamsUnknown = Class.new(StandardError)

  def call(params = {})
    theme_ids = Array(params.delete(:theme_ids))
    category_ids = Array(params.delete(:category_ids))
    comments = Array(params.delete(:comments))
    limit = params.delete(:limit) || 20

    avg_by_theme = params.delete(:avg_by_theme)
    avg_by_category = params.delete(:avg_by_category)

    query = Review

    review_themes_was_joined = false
    themes_was_joined = false

    if theme_ids.present?
      query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
      query = query.where('rt.theme_id IN (?)', theme_ids)
      review_themes_was_joined = true
    end


    if category_ids.present?
      query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id') unless review_themes_was_joined
      query = query.joins('INNER JOIN themes AS th ON th.id = rt.theme_id')
      query = query.where('th.category_id IN (?)', category_ids)
      themes_was_joined = true
    end


    if comments.present?
      ors = comments.map do |comment|
        safe_comment = ActiveRecord::Base.sanitize_sql_like(comment)
        "comment LIKE '%s'" % ['%' + safe_comment + '%']
      end
      query = query.where(ors.map { |s| "(#{s})" }.join(' OR '))
    end


    if avg_by_theme
      query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id') unless review_themes_was_joined
      query.group('rt.theme_id').average('rt.sentiment')

    elsif avg_by_category
      query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id') unless review_themes_was_joined
      query = query.joins('INNER JOIN themes AS th ON th.id = rt.theme_id') unless themes_was_joined
      query.group('th.category_id').average('rt.sentiment')
    else
      query.distinct(:id).limit(limit).all
    end
  end
end
