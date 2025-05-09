module SetLocale
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    # Get locale from URL params (/en/projects)
    parsed_locale = params[:locale]
    
    # Validate that the locale is available
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  # Override the default_url_options to automatically include the locale parameter
  def default_url_options
    { locale: I18n.locale }
  end
end 