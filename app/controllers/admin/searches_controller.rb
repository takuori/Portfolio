class Admin::SearchesController < ApplicationController

  def search
    @comments = Comment.looks(params[:search], params[:word])
  end
end
