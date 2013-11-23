class Transfer::Validator
  attr_reader :source_db, :target_db

  def initialize(source_db, target_db)
    @source_db, @target_db = source_db, target_db
  end

  def validate_before!(source, target = nil)
    target ||= source
    validate_target_empty!(source, target)
  end

  def validate_after!(source, target = nil)
    target ||= source
    validate_records_count!(source, target)
  end

  protected

  def validate_target_empty!(source, target)
    raise "#{target} must be empty." if source_db[target].count != 0
  end

  def validate_records_count!(source, target)
    source_cnt = source_db[source].count
    target_cnt = target_db[target].count
    if source_cnt != target_cnt
      raise "#{source}.count #{source_cnt} != #{target}.count #{target_cnt}"
    end
  end
end
