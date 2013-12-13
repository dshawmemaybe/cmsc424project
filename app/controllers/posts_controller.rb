require 'uuid'
require 'find'

class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.find_by_sql("SELECT * FROM POSTS")

    respond_to do |format|
      format.html {}
      format.json { render json: @posts }
    end
  end

  def mainindex
    @posts = Post.find_by_sql("SELECT * FROM POSTS")

    respond_to do |format|
      format.html { render action: "index", layout: false}
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html { render action: "new", layout: false}# new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  def ask_open_file path = nil
    dialog_chooser "Open File...", Gtk::FileChooser::ACTION_OPEN, Gtk::Stock::OPEN, path
  end

  def dialog_chooser title, action, button, path
    $dde = true
    dialog = Gtk::FileChooserDialog.new(
      title,
      get_win,
      action,
      nil,
      [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
      [button, Gtk::Dialog::RESPONSE_ACCEPT]
    )
    dialog.select_multiple = true
    dialog.current_folder = path if path
    ret = dialog.run == Gtk::Dialog::RESPONSE_ACCEPT ? dialog.filenames : nil
    dialog.destroy
    ret
  end
  # POST /posts
  # POST /posts.json
  def create
    filename = ask_open_file

    @post = Post.new()
    @post.description = filename
=begin
    filename = params[:post][:avatar]

    uuid = UUID.new
    
    fs = File::Stat.new(filename)
    time = fs.ctime
    mtime = fs.mtime
    size = fs.size
    @post.description = "UUID: #{uuid.generate}\n Path: #{filename}\n Created: #{time}\n Modified: #{mtime}\n Size: #{size}"
    @post.name = time
=end

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
