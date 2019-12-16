class AvgByCategorySerializer
  def initialize(data = {}, *args)
    @data = data
  end

  def serializable_hash(*args)
    @data.map do |category_id, avg_sentiment|
      { category_id: category_id, avg_sentiment: avg_sentiment.to_f }
    end
  end
end
