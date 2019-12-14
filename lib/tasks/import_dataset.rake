desc "Import test dataset.\nUsage: rake import_dataset <path=path_to_dir>"
task import_dataset: [:environment] do
  if ENV.key?('path')
    path = File.expand_path(ENV['path'])
    fail("`#{path}' is not exists") unless File.exist?(path)
  else
    path = File.expand_path(File.join(__FILE__, %w(.. .. .. dataset)))
  end

  raw_categories = File.read(File.join(path, %w(categories.json)))
  categories = JSON.parse(raw_categories)

  raw_themes = File.read(File.join(path, %w(themes.json)))
  themes = JSON.parse(raw_themes)

  raw_reviews = File.read(File.join(path, %w(reviews.json)))
  reviews = JSON.parse(raw_reviews)

  ActiveRecord::Base.transaction do
    categories.each do |category|
      category.symbolize_keys!
      Category.find_or_create_by!(category)
    end

    themes.each do |theme|
      theme.symbolize_keys!
      Theme.find_or_create_by!(theme)
    end

    reviews.each do |review|
      review.symbolize_keys!
      review_obj = Review.find_or_create_by!(review.except(:themes).merge(updated_at: review[:created_at]))
      review[:themes].each do |review_theme|
        ReviewTheme.find_or_create_by!(review_theme.merge(review_id: review_obj.id))
      end
    end

    category_last_id = Category.last.id
    Category.connection.execute("ALTER SEQUENCE categories_id_seq RESTART WITH %i" % [category_last_id + 1])

    theme_last_id = Theme.last.id
    Theme.connection.execute("ALTER SEQUENCE themes_id_seq RESTART WITH %i" % [theme_last_id + 1])

    review_last_id = Review.last.id
    Review.connection.execute("ALTER SEQUENCE reviews_id_seq RESTART WITH %i" % [review_last_id + 1])
  end
end
