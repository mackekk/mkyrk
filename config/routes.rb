Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Routes with locale prefix (e.g., /en/about, /sv/contact)
  scope "/:locale" do
    # Route for the contact page
    get "/contact", to: "home#contact", as: :localized_contact
    post "/send_contact", to: "home#send_contact", as: :localized_send_contact

    # Route for the about page
    get "/about", to: "home#about", as: :localized_about

    # Route for the projects page
    get "/projects", to: "home#projects", as: :localized_projects

    # Route for individual project pages
    get "/project0", to: "home#project0", as: :localized_project0
    get "/projectW1", to: "home#projectW1", as: :localized_projectW1
    get "/projectW2", to: "home#projectW2", as: :localized_projectW2

    # Route for the CV page
    get "/cv", to: "home#cv", as: :localized_cv

    # Defines the root path route with locale ("/en", "/sv")
    root to: "home#index", as: :localized_root
  end

  # Non-prefixed routes (will redirect to default locale)
  # Route for the contact page
  get "/contact", to: "home#contact"
  post "/send_contact", to: "home#send_contact"

  # Route for the about page
  get "/about", to: "home#about"

  # Route for the projects page
  get "/projects", to: "home#projects"

  # Route for individual project pages
  get "/project0", to: "home#project0"
  get "/projectW1", to: "home#projectW1"
  get "/projectW2", to: "home#projectW2"

  # Route for the CV page
  get "/cv", to: "home#cv"

  # Defines the root path route ("/")
  root to: redirect("/sv")

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # PROBLEM:
  # - Chrome DevTools mobile emulation sends Accept headers with application/xhtml+xml format
  # - Rails strictly requires controllers to explicitly support each format
  # - This leads to 406 Not Acceptable errors when testing mobile views
  #
  # SOLUTION:
  # - Add a catch-all route specifically for requests with application/xhtml+xml Accept headers
  # - Route these requests to a controller that forces HTML format
  # - Only apply this in development environment to avoid affecting production behavior
  # Special route for handling Chrome DevTools mobile emulation requests
  # This needs to be at the end to avoid blocking other routes
  if Rails.env.development?
    match "*path", to: "rails/application#redirect_to_same_path", via: :all, constraints: lambda { |request|
      request.headers["HTTP_ACCEPT"]&.include?("application/xhtml+xml")
    }
  end
end
