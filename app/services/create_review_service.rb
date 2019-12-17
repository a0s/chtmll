class CreateReviewService
  include Dry::Transaction

  step :validate
  step :check_themes
  step :creation

  def validate(params)
    result = CreateReviewContract.new.(params)
    if result.success?
      Success(params)
    else
      Failure(result.errors.to_h)
    end
  end

  def check_themes(params)
    params[:themes].each do |theme_hash|
      theme_hash.symbolize_keys!
      unless Theme.exists?(theme_hash[:theme_id])
        return Failure("theme id #{theme_hash[:theme_id]} is not found")
      end
    end
    Success(params)
  end

  def creation(params)
    review = nil

    begin
      Review.transaction do
        review = Review.create!(comment: params[:comment])
        params[:themes].each do |theme_hash|
          theme_hash.symbolize_keys!
          theme = Theme.find(theme_hash[:theme_id])
          ReviewTheme.create!(theme: theme, review: review, sentiment: theme_hash[:sentiment])
        end
      end
    rescue StandardError => ex
      return Failure(ex.message)
    end

    Success(review)
  end
end