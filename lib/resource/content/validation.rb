# Mixin to handle payload validation.
module ValidationSupport
  def malformed_request?
    if request.post?
      false unless valid?
    else
      false
    end
  end
end
