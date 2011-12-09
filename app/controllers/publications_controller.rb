class PublicationsController < ApplicationController
  # GET /publications
  # GET /publications.xml
  def index
    if params[:id].to_i > 0
      # display all publications
      @list = Sortable::List.new(Publication, params)
    else
      # default: display only own publications
      @list = Sortable::List.new(Publication, params, @user.valid_publications)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @publications }
    end
  end

  # GET /publications/1
  # GET /publications/1.xml
  def show
    @publication = Publication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @publication }
    end
  end

  # GET /publications/new
  # GET /publications/new.xml
  def new
    @publication = Publication.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @publication }
    end
  end

  # GET /publications/1/edit
  def edit
    @publication = Publication.find(params[:id])
  end

  # POST /publications
  # POST /publications.xml
  def create
    @publication = Publication.new(params[:publication])

    respond_to do |format|
      @publication.authors = params[:select_author].map {|str| Author.find_by_id(str.to_i)}
      if @publication.save
        format.html { redirect_to(@publication, :notice => 'Publication was successfully created.') }
        format.xml  { render :xml => @publication, :status => :created, :location => @publication }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @publication.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /publications/1
  # PUT /publications/1.xml
  def update
    @publication = Publication.find(params[:id])

    respond_to do |format|
      unless params[:select_author].blank?
        @publication.authors = params[:select_author].map {|val| Author.find_by_id(val.to_i)}.uniq
      end

      if @publication.update_attributes(params[:publication])
        format.html { redirect_to(@publication, :notice => 'Publication was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @publication.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1
  # DELETE /publications/1.xml
  def destroy
    @publication = Publication.find(params[:id])
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to(publications_url) }
      format.xml  { head :ok }
    end
  end

  # Upload PDF
  def upload_pdf
    publication = Publication.find_by_id(params[:id])
    if publication
      File.open(publication.pdf_name, 'wb') {|f| f.write(params[:publication_pdf].read) }
      publication.pdf = publication.pdf_name
      publication.save

      redirect_to(publication)
    else
      redirect_to(:back)
    end
  end

  def download_pdf
    publication = Publication.find_by_id(params[:id])
    if publication
      send_file publication.pdf_name, :type => 'application/pdf'
    else
      redirect_to(:back)
    end
  end
end
