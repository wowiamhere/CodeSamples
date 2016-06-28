class PostgreSQL::Database
  include Virtus.model

  attribute :deployment, PostgreSQL::Deployment
  attribute :name, String
  attribute :size, Integer

  def client
    deployment.client(name)
  end

    # Passling schema to search, default: public
  def tables schm = "public"
    client.exec(<<-eos
      SELECT 
       nspname AS schemaname, relname, reltuples
      FROM 
        pg_class C
      LEFT JOIN
        pg_namespace N ON (N.oid = C.relnamespace)
      WHERE
        nspname IN ('#{schm}') AND
        relkind='r' 
      ORDER BY 
        reltuples DESC;
    eos
    ).map do |row|
      PostgreSQL::Table.new(name: row['relname'], rows_count: row['reltuples'], database: self, deployment: deployment)
    end
  end

    # Fetcing all schemas to use as for navigation
    # get_schemas returns an array of arrays
  def get_schemas
    a=client.exec(<<-eos
        SELECT DISTINCT
          nspname
        FROM
          pg_class C
        LEFT JOIN
          pg_namespace N ON (N.oid = C.relnamespace)
      eos
      ).values    
  end  

end