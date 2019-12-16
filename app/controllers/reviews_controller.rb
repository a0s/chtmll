class ReviewsController < ApplicationController
  def index
    param! :theme_ids, Array do |a, i|
      a.param! i, Integer, required: true
    end
    param! :category_ids, Array do |a, i|
      a.param! i, Integer, required: true
    end
    param! :comments, Array do |a, i|
      a.param! i, String, required: true
    end
    param! :limit, Integer

    query = params.except(:action, :controller)
    records = QueryService.new.call(query)
    render json: records, each_serializer: ReviewSerializer
  end

  def avg_by_theme
    param! :theme_ids, Array do |a, i|
      a.param! i, Integer, required: true
    end
    param! :category_ids, Array do |a, i|
      a.param! i, Integer, required: true
    end
    param! :comments, Array do |a, i|
      a.param! i, String, required: true
    end

    query = params.except(:action, :controller).merge(avg_by_theme: true)
    data = QueryService.new.call(query)
    render json: data, serializer: AvgByThemeSerializer
  end

  def avg_by_category
    param! :theme_ids, Array do |a, i|
      a.param! i, Integer, required: true
    end
    param! :category_ids, Array do |a, i|
      a.param! i, Integer, required: true
    end
    param! :comments, Array do |a, i|
      a.param! i, String, required: true
    end

    query = params.except(:action, :controller).merge(avg_by_category: true)
    data = QueryService.new.call(query)
    render json: data, serializer: AvgByCategorySerializer
  end

  def create
    param! :comment, String, required: true
    param! :themes, Array, required: true do |a|
      a.param! :theme_id, Integer, required: true
      a.param! :sentiment, Integer, required: true
    end

    review = nil
    Review.transaction do
      review = Review.create!(comment: params[:comment])
      params[:themes].each do |t|
        theme = Theme.find(t[:theme_id])
        ReviewTheme.create!(theme: theme, review: review, sentiment: t[:sentiment])
      end
    end
    render json: review, serializer: ReviewSerializer
  end
end
