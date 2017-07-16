class String
  def underscore
    downcase.tr(' ', '_')
  end
end
