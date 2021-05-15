# frozen_string_literal: true

module PaginationHelper
  def paginate_record(record)
    present_keys = filter_params.select { |key| params.key?(key) }
    if present_keys.size
      search_query = present_keys.map do |key|
        "LOWER(#{key}) LIKE ?"
      end.join(' OR ')

      args = present_keys.map { |key| "%#{params[key].downcase}%" }
      record.where(search_query, *args).page(page)
    else
      record.page(page)
    end
  end

  # TODO: Find out a way to cache this without busting out rails cache or using instance variable
  def page
    Integer(params[:page] || 1)
  end
end
