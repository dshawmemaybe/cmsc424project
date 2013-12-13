class DagrsController < ApplicationController
  # GET /dagrs
  # GET /dagrs.json
  def index
    @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dagrs }
    end
  end

  def mainindex
    @dagrs = Dagr.all

    respond_to do |format|
      format.html { render action: "index", layout: false }# index.html.erb
      format.json { render json: @dagrs }
    end
  end  


  # GET /dagrs/1
  # GET /dagrs/1.json
  def show
    @dagr = Dagr.find_by_sql("SELECT * FROM DAGRS where guid='#{params[:id]}'")[0]

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

  # GET /dagrs/1/edit
  def edit
    @dagr = Dagr.find(params[:id])
  end

  # POST /dagrs
  # POST /dagrs.json
  def create
    uuid = UUID.new.generate.to_s
    name = "test"
    #Dagr.connection.execute("INSERT INTO DAGRS (guid, name) values(#{uuid}, #{name})")
    @dagr = Dagr.new
    @dagr.guid = uuid
    @dagr.name = name
    respond_to do |format|
      if @dagr.save
        format.html { redirect_to @dagr, notice: 'Dagr was successfully created.' }
        format.json { render json: @dagr, status: :created, location: @dagr }
      else
        format.html { render action: "new" }
        format.json { render json: @dagr.errors, status: :unprocessable_entity }
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
