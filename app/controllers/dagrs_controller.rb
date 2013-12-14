class DagrsController < ApplicationController
  # GET /dagrs
  # GET /dagrs.json
  def index
    @dagrs = Dagr.find_by_sql("SELECT * FROM dagrs")
    @mediafiles = Mediafile.find_by_sql("SELECT * FROM mediafiles")
    @connections = Connection.find_by_sql("SELECT * FROM connections")
    @metadatas = Metadata.find_by_sql("SELECT * FROM metadatas")
    @keywords = Keyword.find_by_sql("SELECT * FROM keywords")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dagrs }
    end
  end

  def mainindex
    @dagrs = Dagr.find_by_sql("SELECT * FROM dagrs")
    @mediafiles = Mediafile.find_by_sql("SELECT * FROM mediafiles")
    @connections = Connection.find_by_sql("SELECT * FROM connections")
    @metadatas = Metadata.find_by_sql("SELECT * FROM metadatas")
    @keywords = Keyword.find_by_sql("SELECT * FROM keywords")

    respond_to do |format|
      format.html { render action: "index", layout: false }# index.html.erb
      format.json { render json: @dagrs }
    end
  end  


  # GET /dagrs/1
  # GET /dagrs/1.json
  def show
    @dagr = Dagr.find_by_sql("SELECT * FROM dagrs where dagr_guid='#{params[:id]}'")[0]
    @md = Metadata.find_by_sql("SELECT * FROM metadatas where dagr_guid='#{params[:id]}'")[0]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dagr }
    end
  end

  # GET /dagrs/new
  # GET /dagrs/new.json
  def new
    @dagr = Dagr.new

    respond_to do |format|
      format.html { render action: "new", layout: false}# new.html.erb
      format.json { render json: @dagr }
    end
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

  def newnonhtml
    @dagr = Dagr.new

    respond_to do |format|
      format.html { render action: "newnonhtml", layout: false}# new.html.erb
      format.json { render json: @dagr }
    end
  end

  # GET /dagrs/1/edit
  def edit
    @dagr = Dagr.find(params[:id])
  end

  # POST /dagrs
  # POST /dagrs.json
  def create
    filename = ask_open_file
    if filename == nil
      redirect_to "http://localhost:3000/dagrs"
    else
    uuid = UUID.new.generate.to_s
    name = filename[0]

    #Dagr.connection.execute("INSERT INTO DAGRS (guid, name) values(#{uuid}, #{name})")
    @dagr = Dagr.new
    @dagr.dagr_guid = uuid
    if params[:dagr]["name"].empty? 
      @dagr.name = name
    else
      @dagr.name = params[:dagr]["name"]
    end  
    @dagr.save
   
    @metadata = Metadata.new
    @metadata.dagr_guid = uuid
    @metadata.filetype = File.extname(name)
    @metadata.filesizebytes = File.size(name)
    @metadata.lastmodifiedtime = File.mtime(name)
    @metadata.creationtime = File.ctime(name)
    @metadata.deletiontime = nil
    @metadata.has_components = false
    @metadata.creationauthor = File.stat(name).uid

    @metadata.save

    mediauuid = UUID.new.generate.to_s  
    @mediafile = Mediafile.new
    @mediafile.media_guid = mediauuid
    @mediafile.dagr_guid = uuid
    @mediafile.filetype = ".mp4"
    @mediafile.name = name
    
    @mediafile.save

    respond_to do |format|
        format.html { redirect_to @dagr, notice: 'Dagr was successfully created.' }
        format.json { render json: @dagr, status: :created, location: @dagr }
    end
  end
  end

  # PUT /dagrs/1
  # PUT /dagrs/1.json
  def update
    @dagr = Dagr.find(params[:id])

    respond_to do |format|
      if @dagr.update_attributes(params[:dagr])
        format.html { redirect_to @dagr, notice: 'Dagr was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dagr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dagrs/1
  # DELETE /dagrs/1.json
  def destroy
    @dagr = Dagr.find(params[:id])
    @dagr.destroy

    respond_to do |format|
      format.html { redirect_to dagrs_url }
      format.json { head :no_content }
    end
  end
end
