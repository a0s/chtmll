module Steps
  class ProcessCategoryIds
    include Dry::Transaction::Operation

    def call(params)
      if params[:category_ids].present?
        unless params[:review_themes_was_joined]
          params[:query] = params[:query].joins('INNER JOIN review_themes AS rt ON rt.review_id = reviews.id')
        end
        params[:query] = params[:query].joins('INNER JOIN themes AS th ON th.id = rt.theme_id')
        params[:query] = params[:query].where('th.category_id IN (?)', params[:category_ids].map(&:to_i))
        params[:themes_was_joined] = true
      end
      params
    end
  end
end
