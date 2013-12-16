require 'uuid'
require 'find'

class QueriesController < ApplicationController
  # GET /posts
  # GET /posts.json
  def metadataquery
    @dagrs = []
    @filetypes = Metadata.find_by_sql("SELECT DISTINCT filetype FROM metadatas")
    @creationauthors = Metadata.find_by_sql("SELECT DISTINCT creationauthor FROM metadatas")

    respond_to do |format|
      format.html { render action: "metadataquery", layout: false}
      format.json { render json: @dagrs }
    end
  end

  def metadataquerymain
    @dagrslist = []
    @filetypes = Metadata.find_by_sql("SELECT DISTINCT filetype FROM metadatas")
    @creationauthors = Metadata.find_by_sql("SELECT DISTINCT creationauthor FROM metadatas")

    @keywords = params[:keywords]
    @createstart = params[:createstart]
    @createend = params[:createend]
    @modifystart = params[:modifystart]
    @modifyend = params[:modifyend]
    @filestart = params[:filestart]
    @fileend = params[:fileend]

    filetypeslist = []
    creationauthorslist = []

    params.each { |p|
      if (p[0].to_s.include?("file."))
        filetypeslist.push(p[1])
      end
      if (p[0].to_s.include?("creator."))
        if (p[1] == "None")
        creationauthorslist.push("")
        else
          creationauthorslist.push(p[1])
        end
      end
    }

    createstring = ""
    modifystring = ""
    filesizestring = ""
    keywordstring = ""
    filetypesstring = ""
    creationauthorsstring = ""

    query = "SELECT dagr_guid FROM metadatas WHERE "

    if @createstart == ""
    else 
      createstring += " AND filecreationtime >= '#{@createstart}' "
    end  

    if @createend == ""
    else 
      createstring += " AND filecreationtime <= '#{@createend}' "
    end  

    if @modifystart == ""
    else 
      modifystring += " AND lastmodifiedtime >= '#{@modifystart}' "
    end  

    if @modifyend == ""
    else 
      modifystring += " AND lastmodifiedtime <= '#{@modifyend}' "
    end

    if @filestart == ""
    else
      filesizestring += " AND filesizebytes >= #{@filestart} "  
    end

    if @fileend == ""
    else
      filesizestring += " AND filesizebytes <= #{@fileend} "   
    end

    filetypesstring += " (filetype='#{filetypeslist[0]}' "
    if (filetypeslist.size == 1)
      filetypesstring += ')'
    end
    1.upto(filetypeslist.size-1) do |i|
      filetypesstring += " OR filetype='#{filetypeslist[i]}' "
      if i == filetypeslist.size-1 
        filetypesstring += ')'
      end
    end

    creationauthorsstring += "AND (creationauthor='#{creationauthorslist[0]}'"
    if (creationauthorslist.size == 1)
      creationauthorsstring += ')'
    end
    1.upto(creationauthorslist.size-1) do |i|
      creationauthorsstring += " OR creationauthor='#{creationauthorslist[i]}'"
      if i == creationauthorslist.size-1
        creationauthorsstring += ')'
      end
    end

    query += filetypesstring += createstring += modifystring += filesizestring += keywordstring += creationauthorsstring
    puts query


    @dagrs = []
    @dagrslist = Metadata.find_by_sql(query)
    puts "size: #{@dagrslist.size}"

    @dagrslist.each { |dagr|
      @dagrs.push(Dagr.find_by_sql("SELECT * from dagrs where dagr_guid='#{dagr.dagr_guid}'"))

    }

    @dagrs = @dagrs.flatten

    respond_to do |format|
      format.html {}
      format.json { render json: @dagrs }
    end
  end

  def duplicatequery
    @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS")

    respond_to do |format|
      format.html { render action: "duplicatequery", layout: false}
      format.json { render json: @dagrs }
    end
  end

  def duplicatequerymain
    @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS")

    respond_to do |format|
      format.html {}
      format.json { render json: @dagrs }
    end
  end

  def timequery
    if params[:start].nil?
      @dagrs = []
     else 
      puts params[:start]
     @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS WHERE dagrcreationtime >= '#{params[:start]}' AND dagrcreationtime <= '#{params[:end]}'")
    end
    respond_to do |format|
      format.html { render action: "timequery", layout: false}
      format.json { render json: @dagrs }
    end
  end

  def timequerymain
    if params[:start] == ""
      @dagrs = []
     else 
      puts params[:start]
     @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS WHERE dagrcreationtime >= '#{params[:start]}' AND dagrcreationtime <= '#{params[:end]}'")
    end

    @start = params[:start]
    @end = params[:end]
    respond_to do |format|
      format.html {}
      format.json { render json: @dagrs }
    end
  end

  def reachquery
    @dagrslist = Dagr.find_by_sql("SELECT * FROM dagrs")
    @mediafileslist = Mediafile.find_by_sql("SELECT * FROM mediafiles")
    @dagrs = []
    @mediafiles = []
    respond_to do |format|
      format.html { render action: "reachquery", layout: false}
      format.json { render json: @dagrs }
    end
  end

  def reachquerymain
    @dagrslist = Dagr.find_by_sql("SELECT * FROM dagrs")
    @mediafileslist = Mediafile.find_by_sql("SELECT * FROM mediafiles")
    dagr = params[:selecteddagr]
    @dagrs = Dagr.find_by_sql("SELECT * FROM dagrs where dagr_guid in ((SELECT parent_guid FROM connections where child_guid='#{dagr}') UNION (SELECT child_guid FROM connections where parent_guid='#{dagr}'))")
    @mediafiles = Mediafile.find_by_sql("SELECT * FROM mediafiles where media_guid in ((SELECT parent_guid FROM connections where child_guid='#{dagr}') UNION (SELECT child_guid FROM connections where parent_guid='#{dagr}'))")

    respond_to do |format|
      format.html {}
      format.json { render json: @dagrs }
    end
  end

  def orphanquery
    @dagrs = []

    respond_to do |format|
      format.html { render action: "orphanquery", layout: false}
      format.json { render json: @dagrs }
    end
  end

  def orphanquerymain
    @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS WHERE dagr_guid NOT IN (SELECT parent_guid FROM connections)")

    respond_to do |format|
      format.html {}
      format.json { render json: @dagrs }
    end
  end
end
