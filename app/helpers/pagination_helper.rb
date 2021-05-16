# frozen_string_literal: true

module PaginationHelper
  def paginate_record(record, filter_params = [])
    present_keys = filter_params.select { |key| params.key?(key) }
    if present_keys.empty?
      record.page(page)
    else
      search_query = present_keys.map do |key|
        "LOWER(#{key}) LIKE ?"
      end.join(' OR ')

      args = present_keys.map { |key| "%#{params[key].downcase}%" }
      record.where(search_query, *args).page(page)
    end
  end
end
