class ReviewsController < ApplicationController
  def index
    SearchReviewService.new.(params.as_json.symbolize_keys) do |result|
      result.success do |records|
        render json: records, each_serializer: ReviewSerializer
      end

      result.failure :validate do |error|
        render status: 422, json: { error: error }
      end
    end
  end

  def avg_by_theme
    AverageByThemeService.new.(params.as_json.symbolize_keys) do |result|
      result.success do |array|
        render json: array, serializer: AverageByThemeSerializer
      end

      result.failure :validate do |error|
        render status: 422, json: { error: error }
      end
    end
  end

  def avg_by_category
    AverageByCategoryService.new.(params.as_json.symbolize_keys) do |result|
      result.success do |array|
        render json: array, serializer: AverageByCategorySerializer
      end

      result.failure :validate do |error|
        render status: 422, json: { error: error }
      end
    end
  end

  def create
    CreateReviewService.new.(params.as_json.symbolize_keys) do |result|
      result.success do |review|
        render json: review, serializer: ReviewSerializer
      end

      result.failure :validate do |error|
        render status: 422, json: { error: error }
      end

      result.failure :check_themes do |error|
        render status: 400, json: { error: error }
      end

      result.failure :creation do |error|
        render status: 500, json: { error: error }
      end
    end
  end
end
