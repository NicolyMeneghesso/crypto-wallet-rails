class ApplicationController < ActionController::Base
    before_action :set_locale

    def set_locale
        if params[:locale].present?
            cookies[:language] = params[:locale] 
        end

        I18n.locale = cookies[:language] || I18n.default_locale
    end
end
