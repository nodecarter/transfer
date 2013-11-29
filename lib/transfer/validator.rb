class Transfer::Validator
  attr_reader :source_db, :target_db

  def initialize(source_db, target_db)
    @source_db, @target_db = source_db, target_db
  end

  def validate_before!(table_name)
    validate_target_empty!(table_name)
  end

  def validate_after!(table_name)
    validate_records_count!(table_name)
  end

  protected

  def validate_target_empty!(table_name)
    if target_db[table_name].count != 0
      raise "#{table_name} must be empty. You can skip this table by including in exclude_tables list in config " +
          "or you can delete all data in this table by including in truncate_tables list."
    end
  end

  def validate_records_count!(table_name)
    source_cnt = source_db[table_name].count
    target_cnt = target_db[table_name].count
    if source_cnt != target_cnt
      raise "source #{table_name}.count #{source_cnt} != target #{table_name}.count #{target_cnt}"
    end
  end
end
