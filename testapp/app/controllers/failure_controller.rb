class FailureController < ApplicationController
  def updater
    head(:fail)
    # respond_to do |format|
    #       format.html { render :text => "<span>html failure</span>" }
    #       format.js   { render :text => { :is_success => false }.to_json }
    #     end
  end
end