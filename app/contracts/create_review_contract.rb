class CreateReviewContract < Dry::Validation::Contract
  params do
    required(:comment).value(:string)
    required(:themes).value(:array, min_size?: 1).each do
      hash do
        required(:theme_id).value(:integer)
        required(:sentiment).value(:integer)
      end
    end
  end
end