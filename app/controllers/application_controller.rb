class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  before_filter :authorize, :except => [:login, :logout]

  # handle errors from locking
  rescue_from ActiveRecord::StaleObjectError, :with => :stale_object

  AcceptedLocaleInfo = [['en', 'English'], ['de', 'Deutsch']]
  AcceptedLocales = AcceptedLocaleInfo.transpose[0]

  ModelInfo = Struct.new(:name, :model_id, :klass, :symbol)
  FilterInfo = Struct.new(:regexp, :ignorecase, :attribute, :index)

  DisplayModels = [
    ModelInfo.new(:publication, 1, Publication, :publications),
    ModelInfo.new(:author,      2, Author,      :authors),
    ModelInfo.new(:call,        7, Call,        :calls),
    ModelInfo.new(:reminder,    8, Reminder,    :reminders),
    ModelInfo.new(:conference,  3, Conference,  :conferences),
    ModelInfo.new(:journal,     4, Journal,     :journals),
    ModelInfo.new(:book,        5, Book,        :books),
    ModelInfo.new(:user,        6, User,        :users)]

  DisplayModelSplits = [3, 6]; # where to insert splits in the model displays

  def set_locale
    current_locale = params[:locale]
    current_locale = 'en' unless AcceptedLocales.include?(current_locale)
    I18n.locale = current_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def model_by_id(model_id)
    DisplayModels.each {|a_model| return a_model if model_id == a_model.model_id}
    nil
  end

  def authorize
    @user = User.find_by_id(session[:user_id])
    unless @user
      flash[:notice] = :please_log_in
      redirect_to(:controller => 'rpubdb', :action => "login")
    end
  end

  def stale_object
    redirect_to(:controller => 'rpubdb', :action => "stale")
  end

  # for index methods: set up the needed regexp variables
  def setup_regexp
    @filter_info = []
    @nr_filters = [APP_CONFIG['setup']['nr_filters'], 1].max
    @nr_filters.times do |i|
      if params["regexp_#{i}"]
        @filter_info << FilterInfo.new(params["regexp_#{i}"], (params["ignorecase_#{i}"] == '1'), params["attr_select_#{i}"].to_sym, i)
      else
        @filter_info << FilterInfo.new('', true, @list.default_filter.attribute, i)
      end
    end
  end
end
