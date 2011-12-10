class BooksController < ApplicationController
  # GET /books
  # GET /books.xml
  def index
    # @books = Book.all
    @list = Sortable::List.new(Book, params)
    if params[:regexp]
      @filter_regexp = params[:regexp]
      @filter_ignorecase = (params[:ignorecase] == '1')
      @filter_attribute = params[:attr_select].to_sym
    else
      @filter_regexp = ''
      @filter_ignorecase = true
      @filter_attribute = @list.default_filter.attribute
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      unless params[:select_author].blank?
        @book.authors = params[:select_author].map {|val| Author.find_by_id(val.to_i)}.uniq
      end
      if @book.save
        format.html { redirect_to(@book, :notice => 'Book was successfully created.') }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      unless params[:select_author].blank?
        @book.authors = params[:select_author].map {|val| Author.find_by_id(val.to_i)}.uniq
      end
      if @book.update_attributes(params[:book])
        format.html { redirect_to(@book, :notice => 'Book was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    if @book.calls.empty? && @book.publications.empty?
      @book.authors = []
      @book.destroy
    end

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end
end
