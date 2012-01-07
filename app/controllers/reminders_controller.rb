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

  # POST /reminders
  # POST /reminders.xml
  def create
    @reminder = Reminder.new(params[:reminder])
    @reminder[:email] = @user.email
    the_call = @reminder.call
    the_conference = @reminder.conference
    if the_call
      @reminder[:send_day] = the_call.deadline - @reminder.offset
    elsif the_conference
      @reminder[:send_day] = the_conference[@reminder[:attribute_name].to_sym] - @reminder.offset
    end

    respond_to do |format|
      if @reminder.save
        format.html { redirect_to(@reminder) }
        format.xml  { render :xml => @reminder, :status => :created, :location => @reminder }
      else
        session[:reminder] = @reminder
        format.html { redirect_to(:action => "set_date", :controller => 'rpubdb') }
        format.xml  { render :xml => @reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.xml
  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy

    respond_to do |format|
      format.html { redirect_to(reminders_url) }
      format.xml  { head :ok }
    end
  end
end
