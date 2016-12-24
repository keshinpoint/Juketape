class StaticController < ApplicationController
  skip_before_action :require_login

  def terms_of_use
  end

  def contact_us
  end

  def privacy_policy
  end
end