require 'sqlite3'

class SetupDB
  def self.setup_db
    sqlite_db = File.join(File.dirname(__FILE__), 'test.sqlite3')
    db = SQLite3::Database.new( sqlite_db )
    db.execute( "DROP TABLE users;" ) rescue nil
  
    # Create the table
    db.execute( "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, email VARCHAR(100), name VARCHAR(100));" )
  
    # Lets populate some seed data
    db.execute( "INSERT INTO users VALUES(1, 'john@example.com', 'John Doe');" )
    db.execute( "INSERT INTO users VALUES(2, 'jane@example.com', 'Jane Smith');" )
  
    ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => sqlite_db)
  end
end