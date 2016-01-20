require 'pg'
require 'pry'
# gem 'bcrypt'
# gem 'redcarpet'

module Forum
  class Server < Sinatra::Base

  	get '/' do
      db = database_connection
      # put this variable in get so the variable can be accessed in our drop down menu
      @topics = db.exec("SELECT * FROM topics").to_a

      erb :index
    end

   post '/' do
        title = params["title"]
        msg = params["msg"]
        username = params["username"]
        votes = params["votes"].to_i
        topics_id = params["topics_id"].to_i

        db = database_connection
        
        new_thread = db.exec_params(
              "INSERT INTO threads (title, msg, username, votes, topics_id) VALUES ($1, $2, $3, $4, $5)",
              [title, msg, username, votes, topics_id])

        @new_thread_submitted = true

        erb :index
    end

    def database_connection
      PG.connect(dbname: 'project_forum_test')
    end



	end
end

# title, msg, username, votes, topics_id