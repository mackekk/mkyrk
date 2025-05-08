class HomeController < ApplicationController
  # Add protection for CSRF in API endpoints
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, only: [:send_contact], if: -> { request.format.json? }
  
  def index
    # This is our Hello World page
  end

  def contact
    # This renders the contact page (app/views/home/contact.html.erb)
  end

  def send_contact
    # Parse JSON if it's a JSON request
    if request.format.json?
      params_data = JSON.parse(request.body.read) rescue {}
      name = params_data['name']
      email = params_data['email']
      message = params_data['message']
    else
      # Regular form submission
      name = params[:name]
      email = params[:email]
      message = params[:message]
    end
    
    # Validate input
    if name.blank? || email.blank? || message.blank?
      respond_to do |format|
        format.html { redirect_to contact_path, alert: "Alla fält måste fyllas i." }
        format.json { render json: { success: false, error: "Alla fält måste fyllas i." }, status: :unprocessable_entity }
      end
      return
    end
    
    # Send the email
    begin
      ContactMailer.contact_message(name, email, message).deliver_now
      
      respond_to do |format|
        format.html { redirect_to contact_path, notice: "Ditt meddelande har skickats!" }
        format.json { render json: { success: true, message: "Ditt meddelande har skickats!" } }
      end
    rescue => e
      Rails.logger.error("Email sending failed: #{e.message}")
      
      respond_to do |format|
        format.html { redirect_to contact_path, alert: "Ett fel uppstod. Vänligen försök igen senare." }
        format.json { render json: { success: false, error: "Ett fel uppstod. Vänligen försök igen senare." }, status: :internal_server_error }
      end
    end
  end

  def about
    # This renders the about page (app/views/home/about.html.erb)
  end

  def projects
    # This renders the projects page (app/views/home/projects.html.erb)
  end

  def cv
    # This renders the CV page (app/views/home/cv.html.erb)
  end
end 