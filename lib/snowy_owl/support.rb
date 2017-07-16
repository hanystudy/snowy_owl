module SnowyOwl
  module Support
    # Avoid conflict with other libraries when using open class for compatibility
    # refine can be well supported in ruby 2.3.0 and above
    def self.to_underscore(str)
      str.downcase.tr(' ', '_')
    end
  end
end
