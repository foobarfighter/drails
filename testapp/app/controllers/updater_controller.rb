class UpdaterController < ApplicationController
  def success
    sleep 3
    respond_to do |format|
      format.html { render :text => "success_html" }
      format.js { render :text => "<div id='success_js'>success_js</div>" }
    end
  end
  
  def failure
    respond_to do |format|
      format.html { render :text => "failure_html" }
      format.js { render :text => "<div id='failure_js'>failure_js</div>" }
    end
  end
end