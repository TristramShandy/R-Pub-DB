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
    setup_regexp

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
    user_author = @user.author
    @default_authors = (user_author.nil? ? [] : [user_author])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @publication }
    end
  end

  # GET /publications/1/edit
  def edit
    @publication = Publication.find(params[:id])

    # check attribute access rights
    is_owner, is_manager = @publication.user_relation(@user)
    @may_edit = (@user.is_office? || is_owner) # only office and the owners may edit the content
    unless is_owner || is_manager || @user.is_office?
      redirect_to(publications_url)
    end
  end

  # POST /publications
  # POST /publications.xml
  def create
    @publication = Publication.new(params[:publication])

    respond_to do |format|
      unless params[:select_author].blank?
        @publication.authors = params[:select_author].map {|val| Author.find_by_id(val.to_i)}
      end
      @publication.status = Publication::StatusValues::Idea
      if (! @publication.authors.empty?) && @publication.save
        APP_CONFIG["special_roles"]["coordinator"].each do |a_coordinator|
          AutoMailer.new_idea(@publication, a_coordinator).deliver
        end
        format.html { redirect_to(@publication) }
        format.xml  { render :xml => @publication, :status => :created, :location => @publication }
      else
        @default_authors = @publication.authors
        @err_no_authors = @publication.authors.empty?
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

      case params[:scope]
      when '0'
        # Conference
        scope = Conference.find_by_id(params[:select_conf].to_i)
        if scope
          @publication[:conference_id] = scope.id
          @publication[:journal_id] = nil
          @publication[:book_id] = nil
        end
      when '1'
        # Journal
        scope = Journal.find_by_id(params[:select_jour].to_i)
        if scope
          @publication[:conference_id] = nil
          @publication[:journal_id] = scope.id
          @publication[:book_id] = nil
        end
      when '2'
        # Book
        scope = Book.find_by_id(params[:select_book].to_i)
        if scope
          @publication[:conference_id] = nil
          @publication[:journal_id] = nil
          @publication[:book_id] = scope.id
        end
      when '3'
        # Other
        @publication[:conference_id] = nil
        @publication[:journal_id] = nil
        @publication[:book_id] = nil
      end

      if @publication.update_attributes(params[:publication])
        format.html { redirect_to(@publication) }
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
    @publication.authors = []
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to(publications_url) }
      format.xml  { head :ok }
    end
  end

  def change_status
    publication = Publication.find_by_id(params[:id].to_i)
    if publication && publication.check_new_status(params[:target].to_i)
      publication.save
    end
    redirect_to(:back)
  end

  # Upload PDF
  def upload_pdf
    publication = Publication.find_by_id(params[:id])
    if publication && params[:publication_pdf]
      data = params[:publication_pdf].read
      if data.blank?
        flash[:notice] = :pdf_not_found
      else
        File.open(publication.pdf_name, 'wb') {|f| f.write(data) }
        publication.pdf = publication.pdf_name
        publication.save
        flash[:notice] = :pdf_uploaded
      end
    else
      flash[:notice] = :pdf_not_found
    end
    redirect_to(:back)
  end

  # Download PDF
  def download_pdf
    publication = Publication.find_by_id(params[:id])
    if publication
      send_file publication.pdf_name, :type => 'application/pdf'
    else
      redirect_to(:back)
    end
  end
end
