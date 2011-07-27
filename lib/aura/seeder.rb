module Aura::Seeder
  def self.registered(app)
    app.extend ClassMethods
  end

  module ClassMethods
    def flush!(&blk)
      blk = lambda { |*a| }  unless block_given?

      tables = self.database.tables

      tables.each do |table|
        blk.call(:drop_table, table)
        self.database.drop_table table
      end
    end

    def seed(type=nil, &blk)
      blk = lambda { |*a| }  unless block_given?

      Aura.models.each { |m|
        blk.call :seed, m.title_plural
        m.seed(type, &blk)
      }
    end

    def seed!(type=nil, &blk)
      blk = lambda { |*a| }  unless block_given?

      Aura.models.each { |m|
        blk.call :seed, m.title_plural
        m.seed!(type, &blk)
      }
    end
  end
end
