class PostgreSQL::Table
  include Virtus.model

  attribute :database, PostgreSQL::Database
  attribute :deployment, PostgreSQL::Deployment

  attribute :name, String

  def client
  		deployment.client(database.name)
  end

  	# Fetching table column types and names
  def table_rows_types
		client.exec(<<-eos
			SELECT 
				a.attname as column_name, 
				format_type(a.atttypid, a.atttypmod) AS data_type
			FROM 
				pg_attribute a
			JOIN 
				pg_class b ON (a.attrelid = b.relfilenode)
			WHERE 
				b.relname = '#{name}' and a.attstattarget = -1;
			eos
				).to_a
  end

  	# Getting table data to display
  def table_info
		client.exec(<<-eos
			SELECT 
        *
      FROM 
        #{name}
			eos
			).values    
	end

		# Get table names
  def get_table_names schm
    client.exec(<<-eos
      SELECT 
        relname
      FROM pg_class C
      LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
      WHERE 
        nspname IN ('#{schm}') AND
        relkind='r' 
      ORDER BY reltuples DESC;
    eos
    ).to_a
   end
end