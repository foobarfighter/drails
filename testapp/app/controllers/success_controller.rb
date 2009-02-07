class SuccessController < ApplicationController
  def updater
    respond_to do |format|
      format.html { "<span>html success</span>" }
      format.js   { { :is_success => true }.to_json }
    end
  end
end