require 'uuid'
require 'find'

class QueriesController < ApplicationController
  # GET /posts
  # GET /posts.json
  def metadataquery
    @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS")

    respond_to do |format|
      format.html { render action: "metadataquery", layout: false}
      format.json { render json: @dagrs }
    end
  end

  def metadataquerymain
    @dagrs = Dagr.find_by_sql("SELECT * FROM DAGRS")

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
