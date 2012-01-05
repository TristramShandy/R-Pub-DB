class RemindersController < ApplicationController
  # GET /reminders
  # GET /reminders.xml
  def index
    @list = Sortable::List.new(Reminder, params, @user.valid_reminders)
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
      format.xml  { render :xml => @reminders }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show
    @reminder = Reminder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  # GET /reminders/new
  # GET /reminders/new.xml
  def new
    @reminder = Reminder.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  # Second stage of reminder creation
  def set_date
    @reminder = Reminder.new()
    if params[:for] == 'call'
      @call = Call.find_by_id(params[:select_call])
      if @call
        @reminder[:attribute_name] = 'deadline'
        @reminder[:call_id] = @call.id
      end
    elsif params[:for] == 'conference'
      @conference = Conference.find_by_id(params[:select_conf])
      if @conference
        @reminder[:attribute_name] = 'deadline'
        @reminder[:conference_id] = @conference.id
      end
    end

    respond_to do |format|
      if @call || @conference
        format.html # new.html.erb
        format.xml  { render :xml => @reminder }
      else
        redirect_to :back
      end
    end
  end

  # POST /reminders
  # POST /reminders.xml
  def create
    @reminder = Reminder.new(params[:reminder])
    @reminder[:email] = @user.email
    @reminder[:send_day] = Date.today

    respond_to do |format|
      if @reminder.save
        format.html { redirect_to(@reminder) }
        format.xml  { render :xml => @reminder, :status => :created, :location => @reminder }
      else
        return_hash = {:action => "set_date"}
        if @reminder[:call_id]
          return_hash[:for] = 'call'
          return_hash[:select_call] = @reminder[:call_id]
        else
          return_hash[:for] = 'conference'
          return_hash[:select_conf] = @reminder[:conference_id]
        end
        format.html { render(return_hash) }
        format.xml  { render :xml => @reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.xml
  def destroy
    @reminder = Reminder.find(params[:id])
    if @reminder.publications.empty? && @reminder.books.empty? && @reminder.user.nil?
      @reminder.destroy
    end

    respond_to do |format|
      format.html { redirect_to(reminders_url) }
      format.xml  { head :ok }
    end
  end
end
