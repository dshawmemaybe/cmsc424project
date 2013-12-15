require 'etc'
require 'dparser'
require 'mechanize'

class DagrsController < ApplicationController
    include DagrsHelper
  # GET /dagrs
  # GET /dagrs.json
  def index
    @dagrs = Dagr.find_by_sql("SELECT * FROM dagrs")
    @mediafiles = Mediafile.find_by_sql("SELECT * FROM mediafiles")
    @connections = Connection.find_by_sql("SELECT * FROM connections")
    @metadatas = Metadata.find_by_sql("SELECT * FROM metadatas")
    @keywords = Keyword.find_by_sql("SELECT * FROM keywords")
    @annotations = Annotation.find_by_sql("SELECT * FROM annotations")

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
    @annotations = Annotation.find_by_sql("SELECT * FROM annotations")

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
    @keywords = Keyword.find_by_sql("SELECT * FROM keywords where dagr_guid='#{params[:id]}'")
    @connections = Connection.find_by_sql("SELECT * FROM connections where parent_guid='#{params[:id]}'")

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

  def newurl
    filename = params[:url]
    if filename == nil
      redirect_to "http://localhost:3000/dagrs"
    else
      uuid = UUID.new.generate.to_s
      name = filename

      filetype = ".html"
      components = parseHTML(true, name)

      size = 0
      components.each { |component|
        size += component.size
      }
      #Dagr.connection.execute("INSERT INTO DAGRS (guid, name) values(#{uuid}, #{name})")
      @dagr = Dagr.new
      @dagr.dagr_guid = uuid
      @dagr.name = name
      @dagr.dagrcreationtime = Time.now
      @dagr.dagrdeletiontime = nil
      @dagr.has_components = false
      if size > 0
        @dagr.has_components = true
      end
      @dagr.deleted = false

      @dagr.save
     
      if filetype.eql?(".html")
        components[0].each { |imghash|
            createMediafile(uuid, "image",imghash,name)
        } unless components[0].nil?
        components[1].each { |ahash|
            createMediafile(uuid, "link",ahash,name)
        } unless components[1].nil?
        components[2].each { |iframehash|
            createMediafile(uuid, "iframe",iframehash,name)
        } unless components[2].nil?
        components[3].each { |videohash|
            createMediafile(uuid, "video",videohash,name)
        } unless components[3].nil?
        components[4].each { |audiohash|
            createMediafile(uuid, "audio",audiohash,name)
        } unless components[4].nil?
      end

      @metadata = Metadata.new
      @metadata.dagr_guid = uuid
      @metadata.filetype = filetype
      @metadata.filesizebytes = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}.head(filename)["content-length"].to_i
      @metadata.filecreationtime = nil
      @metadata.lastmodifiedtime = nil
      @metadata.creationauthor = nil

      @metadata.save
    
    respond_to do |format|
        format.html { redirect_to @dagr, notice: 'Dagr was successfully created.' }
        format.json { render json: @dagr, status: :created, location: @dagr }
    end
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

  def createMediafile(uuid, type, hash, name)
  mediauuid = UUID.new.generate.to_s  
  @mediafile = Mediafile.new
  @mediafile.media_guid = mediauuid
  @mediafile.dagr_guid = uuid
  @mediafile.filetype = type
  @mediafile.deleted = false
  @mediafile.deletiontime = nil

  case type
  when "image"
     if !hash["src"].nil?
      @mediafile.name = hash["src"].value
     end
  when "link"
      if !hash["href"].nil?
        @mediafile.name = hash["href"].value
      end
  when "iframe"
      if !hash["src"].nil?
        @mediafile.name = hash["src"].value
      end
  when "video"
  when "audio"
  end  
    
  @mediafile.save  

  @connection = Connection.new
  @connection.parent_guid = uuid
  @connection.parent_name = name
  @connection.child_guid = mediauuid
  @connection.child_name = @mediafile.name

  @connection.save

  hash.keys.each { |key|
    annotation = Annotation.new
    annotation.media_guid = mediauuid
    annotation.annotation = "#{key}:#{hash[key]}"

    annotation.save
  }
  end

  # POST /dagrs
  # POST /dagrs.json
  def create
    filenames = ask_open_file
    if filenames == nil
      redirect_to "http://localhost:3000/dagrs"
    else
    filenames.each { |filename| 
      uuid = UUID.new.generate.to_s
      name = filename

      filetype = File.extname(name)
      components = parseHTML(false,name)

      size = 0
      components.each { |component|
        size += component.size
      }
      #Dagr.connection.execute("INSERT INTO DAGRS (guid, name) values(#{uuid}, #{name})")
      @dagr = Dagr.new
      @dagr.dagr_guid = uuid
      @dagr.name = name
      @dagr.dagrcreationtime = Time.now
      @dagr.dagrdeletiontime = nil
      @dagr.has_components = false
      if size > 0
        @dagr.has_components = true
      end
      @dagr.deleted = false

      @dagr.save
     
      if filetype.eql?(".html")
        components[0].each { |imghash|
            createMediafile(uuid, "image",imghash,name)
        } unless components[0].nil?
        components[1].each { |ahash|
            createMediafile(uuid, "link",ahash,name)
        } unless components[1].nil?
        components[2].each { |iframehash|
            createMediafile(uuid, "iframe",iframehash,name)
        } unless components[2].nil?
        components[3].each { |videohash|
            createMediafile(uuid, "video",videohash,name)
        } unless components[3].nil?
        components[4].each { |audiohash|
            createMediafile(uuid, "audio",audiohash,name)
        } unless components[4].nil?
      end

      @metadata = Metadata.new
      @metadata.dagr_guid = uuid
      @metadata.filetype = filetype
      @metadata.filesizebytes = File.size(name)
      @metadata.filecreationtime = File.ctime(name)
      @metadata.lastmodifiedtime = File.mtime(name)
      @metadata.creationauthor = getAuthor(name)

      @metadata.save
    }
    respond_to do |format|
        format.html { redirect_to @dagr, notice: 'Dagr was successfully created.' }
        format.json { render json: @dagr, status: :created, location: @dagr }
    end
  end
  end

  # PUT /dagrs/1
  # PUT /dagrs/1.json
  def update
    @olddagr = Dagr.find(params[:id])
    keywords = params[:keywords].split(",")
    keywords.each { |k|
      keyword = Keyword.new
      keyword.dagr_guid = params[:id]
      keyword.keyword = k
      keyword.save
    }

    filename = params[:url]
    if filename.eql?("")
    else
      uuid = UUID.new.generate.to_s
      name = filename

      filetype = ".html"
      components = parseHTML(true, name)

      size = 0
      components.each { |component|
        size += component.size
      }
      #Dagr.connection.execute("INSERT INTO DAGRS (guid, name) values(#{uuid}, #{name})")
      @dagr = Dagr.new
      @dagr.dagr_guid = uuid
      @dagr.name = name
      @dagr.dagrcreationtime = Time.now
      @dagr.dagrdeletiontime = nil
      @dagr.has_components = false
      if size > 0
        @dagr.has_components = true
      end
      @dagr.deleted = false

      @dagr.save
     
      if filetype.eql?(".html")
        components[0].each { |imghash|
            createMediafile(uuid, "image",imghash,name)
        } unless components[0].nil?
        components[1].each { |ahash|
            createMediafile(uuid, "link",ahash,name)
        } unless components[1].nil?
        components[2].each { |iframehash|
            createMediafile(uuid, "iframe",iframehash,name)
        } unless components[2].nil?
        components[3].each { |videohash|
            createMediafile(uuid, "video",videohash,name)
        } unless components[3].nil?
        components[4].each { |audiohash|
            createMediafile(uuid, "audio",audiohash,name)
        } unless components[4].nil?
      end

      @metadata = Metadata.new
      @metadata.dagr_guid = uuid
      @metadata.filetype = filetype
      @metadata.filesizebytes = Mechanize.new.head(filename)["content-length"].to_i
      @metadata.filecreationtime = nil
      @metadata.lastmodifiedtime = nil
      @metadata.creationauthor = nil

      @metadata.save

      @connection = Connection.new
      @connection.parent_guid = @olddagr.dagr_guid
      @connection.parent_name = @olddagr.name
      @connection.child_guid = uuid
      @connection.child_name = name

      @connection.save

      sql = "INSERT INTO connections (parent_guid, parent_name, child_guid, child_name) SELECT '#{@olddagr.dagr_guid}' as parent_guid,'#{@olddagr.name}' as parent_name, child_guid, child_name FROM connections where parent_guid='#{uuid}'"
      Connection.connection.execute(sql)
    end

    respond_to do |format|
      if @olddagr.update_attributes(params[:dagr])
        format.html { redirect_to @olddagr, notice: 'Dagr was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @olddagr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dagrs/1
  # DELETE /dagrs/1.json
  def destroy
    @dagr = Dagr.find(params[:id])
    @dagr.deleted = true
    @dagr.dagrdeletiontime = Time.now

    @dagr.save

    sql = "DELETE FROM metadatas WHERE dagr_guid='#{params[:id]}'"
    Metadata.connection.execute(sql)
    
    sql = "UPDATE dagrs SET deleted=true, dagrdeletiontime='#{Time.now}' where dagr_guid in (SELECT child_guid FROM connections where parent_guid='#{params[:id]}')"
    Dagr.connection.execute(sql)

    sql = "DELETE FROM keywords where dagr_guid='#{params[:id]}'"
    Keyword.connection.execute(sql)

    sql = "DELETE FROM connections where parent_guid='#{params[:id]}'"
    Connection.connection.execute(sql)

    sql = "UPDATE mediafiles SET deleted=true, deletiontime='#{Time.now}' where dagr_guid='#{params[:id]}'"
    Connection.connection.execute(sql)

    sql = "DELETE FROM annotations where media_guid IN (SELECT media_guid FROM mediafiles where dagr_guid='#{params[:id]}')"
    Annotation.connection.execute(sql)



    respond_to do |format|
      format.html { redirect_to dagrs_url }
      format.json { head :no_content }
    end
  end
end
