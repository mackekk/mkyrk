# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Email Configuration

The contact form uses Gmail SMTP to send emails. To set this up:

1. Create a Google account or use your existing Gmail account.
2. Generate an "App Password" for your Gmail account:
   - Go to your Google Account > Security
   - Enable 2-Step Verification if not already enabled
   - Go to "App passwords" (under "Signing in to Google")
   - Select "Mail" as the app and "Other" as the device (name it "YourAppName")
   - Google will generate a 16-character password

3. Set up your environment variables:

### For Development:
Create a `.env` file in the project root:
```
GMAIL_USER=your-email@gmail.com
GMAIL_APP_PASSWORD=your-16-char-app-password
```

### For Production (Render):
Set the following environment variables in your Render dashboard:
- `GMAIL_USER`
- `GMAIL_APP_PASSWORD`
- `PRODUCTION_HOST` (your deployed app domain, e.g., example.com)

Note: Ensure your `.env` file is added to `.gitignore` to keep your credentials secure.

