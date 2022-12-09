class ErrorSerializer

  def initialize(error_object)
    @error_object = error_object
  end

  def serialized_json
    {
      error: [
        {
          status: @error_object.status,
          message: @error_object.error_message,
          code: @error_object.code
        }
      ]
    }
  end
end
