class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  AcceptedLocaleInfo = [['en', 'English'], ['de', 'Deutsch']]
  AcceptedLocales = AcceptedLocaleInfo.transpose[0]

  ModelInfo = Struct.new(:name, :model_id, :klass, :symbol)

  DisplayModels = [
    ModelInfo.new(:author,      1, Author,      :authors),
    ModelInfo.new(:conference,  2, Conference,  :conferences),
    ModelInfo.new(:journal,     3, Journal,     :journals),
    ModelInfo.new(:book,        4, Book,        :books),
    ModelInfo.new(:user,        5, User,        :users)]

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
end
