class AvgByThemeSerializer
  def initialize(data = {}, *args)
    @data = data
  end

  def serializable_hash(*args)
    @data.map do |theme_id, avg_sentiment|
      { theme_id: theme_id, avg_sentiment: avg_sentiment.to_f }
    end
  end
end

