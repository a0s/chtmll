module Steps
  class Container
    extend Dry::Container::Mixin

    namespace 'steps' do |ops|
      ops.register 'prepare_query' do
        PrepareQuery.new
      end

      ops.register 'process_theme_ids' do
        ProcessThemeIds.new
      end

      ops.register 'process_category_ids' do
        ProcessCategoryIds.new
      end

      ops.register 'process_comments' do
        ProcessComments.new
      end
    end
  end
end
