class Public::NotificationsController < ApplicationController
  before_action :authenticate_member!
  
  def index
  end
end
