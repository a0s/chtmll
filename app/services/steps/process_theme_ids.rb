module Steps
  class ProcessThemeIds
    include Dry::Transaction::Operation

    def call(params)
      if params[:theme_ids].present?
        params[:query] = params[:query].joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
        params[:query] = params[:query].where('rt.theme_id IN (?)', params[:theme_ids].map(&:to_i))
        params[:review_themes_was_joined] = true
      end
      params
    end
  end
end
