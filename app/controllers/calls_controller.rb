class CallsController < ApplicationController
  # GET /calls
  # GET /calls.xml
  def index
    @list = Sortable::List.new(Call, params)
    setup_regexp

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calls }
    end
  end

  # GET /calls/1
  # GET /calls/1.xml
  def show
    @call = Call.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @call }
    end
  end

  # GET /calls/new
  # GET /calls/new.xml
  def new
    @call = Call.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @call }
    end
  end

  # GET /calls/1/edit
  def edit
    @call = Call.find(params[:id])
  end

  # POST /calls
  # POST /calls.xml
  def create
    @call = Call.new(params[:call])

    respond_to do |format|
      set_scope

      if @call.save
        format.html { redirect_to(@call) }
        format.xml  { render :xml => @call, :status => :created, :location => @call }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @call.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calls/1
  # PUT /calls/1.xml
  def update
    @call = Call.find(params[:id])

    respond_to do |format|
      set_scope

      if @call.update_attributes(params[:call])
        format.html { redirect_to(@call) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @call.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.xml
  def destroy
    @call = Call.find(params[:id])
    @call.destroy

    respond_to do |format|
      format.html { redirect_to(calls_url) }
      format.xml  { head :ok }
    end
  end

  private

  def set_scope
    case params[:scope]
    when '0'
      # Conference
      scope = Conference.find_by_id(params[:select_conf].to_i)
      if scope
        @call[:conference_id] = scope.id
        @call[:journal_id] = nil
        @call[:book_id] = nil
      end
    when '1'
      # Journal
      scope = Journal.find_by_id(params[:select_jour].to_i)
      if scope
        @call[:conference_id] = nil
        @call[:journal_id] = scope.id
        @call[:book_id] = nil
      end
    when '2'
      # Book
      scope = Book.find_by_id(params[:select_book].to_i)
      if scope
        @call[:conference_id] = nil
        @call[:journal_id] = nil
        @call[:book_id] = scope.id
      end
    end
  end

end
