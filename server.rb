# parse
require 'pg'
require 'pry'
# gem 'bcrypt'
# gem 'redcarpet'

module Forum
  class Server < Sinatra::Base

  set :method_override, true

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
        topics_id = params["topics_id"].to_i

        db = database_connection
        
        new_thread = db.exec_params(
              "INSERT INTO threads (title, msg, username,topics_id, votes) VALUES ($1, $2, $3, $4, $5)",
              [title, msg, username,topics_id,0])

        @new_thread_submitted = true

        erb :index
    end

    get '/threads/:thread_id' do
        db = database_connection
        @thread_id = params[:thread_id].to_i
        @thread = db.exec("SELECT * FROM threads WHERE id = #{@thread_id}").first
        @all_comments=db.exec_params("SELECT * FROM comments WHERE thread_id = $1",[@thread_id]).to_a

        erb :threads
    end

    post '/threads/:thread_id' do
        @thread_id = params[:thread_id].to_i
        msg = params["msg"]
        username = params["username"]

        db = database_connection
        
        db.exec_params(
              "INSERT INTO comments (thread_id, msg, username) VALUES ($1, $2, $3)",
              [@thread_id, msg, username])

        redirect "/threads/#{@thread_id}"
    end

    put '/threads/:thread_id' do
        db = database_connection
        @thread_id = params[:thread_id].to_i

        @up_votes = params["up_votes"]

        if @up_votes == "YES!"
          db.exec_params("UPDATE threads SET votes = votes + 1 WHERE id = $1",[@thread_id])
        elsif @up_votes == "NO!"
          db.exec_params("UPDATE threads SET votes = votes - 1 WHERE id = $1",[@thread_id])    
        end

        redirect "/threads/#{@thread_id}"
    end    

    def database_connection
      PG.connect(dbname: 'project_forum_test')
    end



	end
end