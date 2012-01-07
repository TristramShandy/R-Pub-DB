class RpubdbController < ApplicationController
  # The rpubdb controller is designed as the encompassing controller of this application.

  def login
    reset_session

    if request.post?
      if params[:name].blank?
        flash[:notice] = :enter_name
      elsif params[:password].blank?
        flash[:notice] = :enter_password
      else
        user = User.authenticate(params[:name], params[:password])
        if user
          session[:user_id] = user.id
          redirect_to :publications
        else
          flash[:notice] = :invalid_password
        end
      end
    end
  end

  def logout
    reset_session
    flash[:notice] = :logged_out
  end

  def home
    @pending_publications = @user.publications.find(:all)
  end

  def list
    @session[model_id] = params[:id].to_i unless params[:id].blank?

    @model = model_by_id(@session[model_id])
    if @model
      if @user && @user.may_see_model?(@session[model_id])
        @items = @model.klass.find(:all)
      else
        flash[:notice] = [:not_allowed_to_see, {:name => @model[:name]}]
        redirect_to :publications
      end
    else
      flash[:notice] = :illegal_model
      redirect_to :publications
    end
  end

  # called when a stale object is encountered through locking
  def stale
  end

  # Second stage of reminder creation
  # This is in the rpubdb controller due to those fucking annoying RESTful routes that always get in the way...
  def set_date
    if session[:reminder]
      @reminder = session[:reminder]
      @call = @reminder.call
      @conference = @reminder.conference
      session[:reminder] = nil
      logger.info("Using reminder from session")
    else
      @reminder = Reminder.new(:offset => params[:offset].to_i, :attribute_name => params[:attribute_name])
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
      logger.info("Using generated reminder")
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

  private

  #####################################################################
  #
  # Non-public methods
  #

  def authorize
    @user = User.find_by_id(session[:user_id])
    unless @user
      flash[:notice] = :please_log_in
      redirect_to(:action => "login")
    end
  end
end
