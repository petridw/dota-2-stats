# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# --- Set up constants for environment ---
# items per page for pagination
ITEMS_PER_PAGE = 50

# limit requests to Steam to 3 requests per 1 second
SlowWeb.limit('api.steampowered.com', 3, 1)