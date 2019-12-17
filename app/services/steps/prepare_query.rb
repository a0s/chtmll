module Steps
  class PrepareQuery
    include Dry::Transaction::Operation

    def call(params)
      params[:query] = Review
      params[:review_themes_was_joined] = false
      params[:themes_was_joined] = false
      params[:limit] ||= 20
      params
    end
  end
end
