module ActiveRecordResolver
  def self.call(_, args, _)
    GlobalID::Locator.locate(args[:id])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
