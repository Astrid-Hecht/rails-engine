class NoResultsSerializer

  def initialize(error_object)
    @error_object = error_object
  end

  def serialized_json
    {
      data: @error_object
    }
  end
end