class ErrorSerializer
  def self.serialize(errors)
    return if errors.nil?

    json = {
      success: false,
      errors: {}
    }

    if errors.is_a?(ActiveModel::Errors)
      errors.messages.each do |field, messages|
        json[:errors][field] = messages
      end
    elsif errors.is_a?(String)
      json[:errors][:base] = [ errors ]
    else
      json[:errors][:base] = [ errors.to_s ]
    end

    json
  end
end
