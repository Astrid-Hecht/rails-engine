class NoResultsSerializer

  def initialize(error_object, search_type)
    @error_object = error_object
    @search_type = convert_type(search_type)
  end

  def serialized_json
    {
      error: @error_object,
      data: @search_type
    }
  end

  def convert_type(type)
    return [] if type == :find_all
    return @error_object if type == :find_one
  end
end
