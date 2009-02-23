class UpdaterController < ApplicationController
  def success
    respond_to do |format|
      format.html { render :text => "<div id='success_html'>success_html</div>" }
      format.js { render :text => "<div id='success_js'>success_js</div><script type='text/javascript'>jsFunc();</script>" }
    end
  end
  
  def failure
    respond_to do |format|
      format.html { render :status => 500, :text => "<div id='failure_html'>failure_html</div>" }
      format.js { render :status => 500, :text => "<div id='failure_js'>failure_js</div><script type='text/javascript'>jsFunc();</script>" }
    end
  end
end
