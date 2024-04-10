class DataTypeMessages
  MESSAGES = {
    true => "Known password data",
    false => "Unknown password data"
  }

  class << self
    def message(is_known)
      MESSAGES[is_known]
    end
  end
end