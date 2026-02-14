class HealthController < ActionController::Base
  def show
    render plain: "OK", status: :ok
  end
end
