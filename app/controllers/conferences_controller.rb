class ConferencesController < ApplicationController
  # GET /conferences
  # GET /conferences.xml
  def index
    # @conferences = Conference.all
    @list = Sortable::List.new(Conference, params)
    setup_regexp

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conferences }
    end
  end

  # GET /conferences/1
  # GET /conferences/1.xml
  def show
    @conference = Conference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conference }
    end
  end

  # GET /conferences/new
  # GET /conferences/new.xml
  def new
    @conference = Conference.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conference }
    end
  end

  # GET /conferences/1/edit
  def edit
    @conference = Conference.find(params[:id])
  end

  # POST /conferences
  # POST /conferences.xml
  def create
    @conference = Conference.new(params[:conference])

    respond_to do |format|
      if @conference.save
        format.html { redirect_to(@conference) }
        format.xml  { render :xml => @conference, :status => :created, :location => @conference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.xml
  def update
    @conference = Conference.find(params[:id])

    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to(@conference) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.xml
  def destroy
    @conference = Conference.find(params[:id])
    if @conference.calls.empty? && @conference.publications.empty?
      @conference.destroy
    end

    respond_to do |format|
      format.html { redirect_to(conferences_url) }
      format.xml  { head :ok }
    end
  end
end
