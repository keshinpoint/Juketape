class WelcomeController < ApplicationController
  layout 'static'
  skip_before_action :require_login

  def index
  end

  def setup_one
  end

  def setup_two
  end

  def onboarding_one  	
  end

  def onboarding_two 	
  end

  def onboarding_three  
  end
  
  def onboarding_four  
  end

  def dashfolio
  end
  
   def invite
  end

  def inbox
  end

  def new_message
  end

  def search
  end

end