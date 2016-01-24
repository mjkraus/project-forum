# parse
require 'pg'
require 'pry'
require 'bcrypt'
require 'redcarpet'
require 'sinatra/cookies'

module Forum
  class Server < Sinatra::Base

  enable :sessions

  set :method_override, true    

  def markdown 
        @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  def current_user
    # ||= is a memoizer. Research further. 
    # saves the user id in the session = keeps the user id until it user ends the session 
    db = database_connection

    if session["user_id"]
      @current_user ||= db.exec_params("SELECT * FROM users WHERE id = $1", [session["user_id"]]).first
    else
      # THE USER IS NOT LOGGED IN
      {}
    end    
  end

  # get '/' do
  #   redirect "/signup"
  # end

  get "/signup" do
      erb :signup
  end  

  post "/signup" do
      db = database_connection
      login_name = params[:login_name]
      encrypted_password = BCrypt::Password.create(params[:login_password])


      # WHAT IS RETURNING ID?

      # if db.exec("SELECT * from users WHERE login_name = $1", [login_name]).to_a ==[] means there is no result
      users = db.exec_params("INSERT INTO users (login_name, login_password_digest) VALUES ($1, $2) RETURNING id", [login_name, encrypted_password]);
      # else
      #say that it already exists.

      #.first is techincally [0]
      #we are tagging the user with their ID. NOW they are logged in.
      #log out by dropping the session OR setting user_id to nothing
      session["user_id"]=users.first["id"]
      # might need a .to_i

      erb :signup_success
    end

    get '/login' do
      erb :login
    end

    post '/login' do
      db = database_connection
      login_name = params[:login_name]
      login_password = params[:login_password]

      @user = db.exec_params("SELECT * FROM users WHERE login_name = $1", [login_name]).first
        if @user
          if BCrypt::Password.new(@user["login_password_digest"]) == login_password
            session["user_id"] = @user["id"]
            # session[:return_to] ||= request.referer
            # binding.pry
            redirect session[:return_to]
          else
            @error = "Invalid Password"
            erb :login
          end
        else
          @error = "Invalid Username"
          erb :login
        end
    end

    get '/logout' do
      session["user_id"] = false
      redirect "/"
    end    

    get '/' do
      db = database_connection

      @popularity = db.exec("SELECT threads.title, threads.votes, topics.name FROM threads INNER JOIN topics ON threads.topics_id=topics.id ORDER BY votes DESC LIMIT 9").to_a
      
      @topic_nav_bar = db.exec("SELECT * FROM topics").to_a
      
      erb :index
    end

    # get '/' do
    #   db = database_connection

    #   @topic_nav_bar = db.exec("SELECT * FROM topics").to_a

    #   erb :layout
    # end

  	get '/create' do
      db = database_connection
      if session["user_id"]
      # put this variable in get so the variable can be accessed in our drop down menu
      @topics = db.exec("SELECT * FROM topics").to_a
      erb :create
      else
        session[:redirect_to] = "/create"
        redirect "/login"
      end
    end

   post '/create' do
        title = params["title"]
        msg = params["msg"]
        # username = session["user_id"] 
        username = current_user['login_name'] #IS THIS OK? 
        topics_id = params["topics_id"].to_i

        db = database_connection
        
        new_thread = db.exec_params(
              "INSERT INTO threads (title, msg, username,topics_id, votes) VALUES ($1, $2, $3, $4, $5)",
              [title, msg, username,topics_id,0])

        # @new_thread_submitted = true need to add an if statement for thread creation

        erb :create
    end

    get '/threads/:thread_id' do
        db = database_connection
        @thread_id = params[:thread_id].to_i
        @thread = db.exec("SELECT * FROM threads WHERE id = #{@thread_id}").first
        @all_comments=db.exec_params("SELECT * FROM comments WHERE thread_id = $1",[@thread_id]).to_a
        thread_msg = @thread["msg"]
        @rendered_thread_msg = markdown.render(thread_msg)
        erb :threads
    end  

    post '/threads/:thread_id' do
        @thread_id = params[:thread_id].to_i
        msg = params["msg"]
        username = current_user['login_name']

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