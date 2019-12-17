module Steps
  class ProcessComments
    include Dry::Transaction::Operation

    def call(params)
      if params[:comments].present?
        ors = params[:comments].map do |comment|
          safe_comment = ActiveRecord::Base.sanitize_sql_like(comment)
          "comment LIKE '%s'" % ['%' + safe_comment + '%']
        end
        if ors.count === 1
          sub_query = ors.first
        else
          sub_query = ors.map { |s| "(#{s})" }.join(' OR ')
        end
        params[:query] = params[:query].where(sub_query)
      end
      params
    end
  end
end
