module Sequel
module Plugins
module AutoSchema
  module ClassMethods
    def sync_schema
      return create_table  unless table_exists?

      db_columns = db.schema(table_name).map { |row| row[0] }
      columns = schema.columns

      db.alter_table(table_name) do
        columns.each do |column|
          # Not present
          if !db_columns.include?(column[:name])
            add_column column[:name], column[:type]
          end

          # Can also do add_index, rename_column
        end
      end

      @db_schema = get_db_schema(true)
    end
  end
end
end
end

