require "sinatra"
require "pg"
require "pry"

configure :development do
  set :db_config, { dbname: "vacation_list_development" }
end

configure :test do
  set :db_config, { dbname: "vacation_list_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

def vacation_all
  db_connection do |conn|
    sql_query = "SELECT * FROM vacations"
    conn.exec(sql_query)
  end
end

def vacation_save(params)
  unless params["destination"].empty?
    db_connection do |conn|
      sql_query = "INSERT INTO vacations (destination) VALUES ($1)"
      data = [params["destination"]]
      conn.exec_params(sql_query, data)
    end
  end
end

def vacation_find(id)
  db_connection do |conn|
    sql_query = "SELECT * FROM vacations WHERE id = $1"
    data = [id]
    conn.exec_params(sql_query, data).first
  end
end

def vacation_comments(id)
  db_connection do |conn|
    sql_query = "SELECT vacations.*, comments.* FROM vacations
        JOIN comments ON vacations.id = comments.vacation_id
        WHERE vacations.id = $1"
    data = [id]
    conn.exec_params(sql_query, data)
  end
end

get "/" do
  redirect "/vacations"
end

get "/vacations" do
  @vacations = vacation_all
  erb :vacations
end

post "/vacations" do
  vacation_save(params)
  redirect "/vacations"
end

get "/vacations/:id" do
  @vacation = vacation_find(params[:id])
  @comments = vacation_comments(params[:id]).to_a
  erb :show
end
