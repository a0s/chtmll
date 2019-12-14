class QueryBuilder
  QueryBuilderParamsUnknown = Class.new(StandardError)

  def call(params = {})
    theme_ids = Array(params.delete(:theme_ids))
    category_ids = Array(params.delete(:category_ids))
    comments = Array(params.delete(:comments))
    sentiment_by_theme = params.delete(:sentiment_by_theme)
    sentiment_by_category = params.delete(:sentiment_by_category)

    fail(QueryBuilderParamsUnknown, params) unless params.blank?

    query = Review

    review_themes_was_joined = false
    themes_was_joined = false

    if theme_ids.present?
      query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
      query = query.where('rt.theme_id IN (?)', theme_ids)

      review_themes_was_joined = true
    end


    if category_ids.present?
      unless review_themes_was_joined
        query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
      end

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


    if sentiment_by_theme
      unless review_themes_was_joined
        query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
      end

      query = query.group('rt.theme_id').average('rt.sentiment')

    elsif sentiment_by_category
      unless review_themes_was_joined
        query = query.joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
      end
      unless themes_was_joined
        query = query.joins('INNER JOIN themes AS th ON th.id = rt.theme_id')
      end

      query = query.group('th.category_id').average('rt.sentiment')
    end

    query
  end
end
