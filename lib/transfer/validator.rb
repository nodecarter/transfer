class Transfer::Validator
  attr_reader :source, :target

  def initialize(source, target)
    @source, @target = source, target
  end

  def validate_before!(target_db)
    validate_target_empty!(target_db)
  end

  def validate_after!(target_db)
    validate_records_count!(target_db)
  end

  protected

  def validate_target_empty!(target_db)
    raise "#{target} must be empty." if target_db[target].count != 0
  end

  def validate_records_count!(target_db)
    source_cnt = source.count
    target_cnt = target_db[target].count
    if source_cnt != target_cnt
      raise "#{source}.count #{source_cnt} != #{target}.count #{target_cnt}"
    end
  end
end
