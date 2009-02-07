class SuccessController < ApplicationController
  def updater
    respond_to do |format|
      format.html { render :text => "<span>html success</span>" }
      format.js   { render :text => { :is_success => true }.to_json }
    end
  end
end