class ToolsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_elections

  def index
    authorize! :index, :tools

    redirect_to edit_user_registration_path unless Features.verifications?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def user_elections
    @all_elections = Election.upcoming_finished.map { |e| e if e.has_valid_location_for? current_user } .compact

    @elections = @all_elections.select { |e| e.is_active? }
    @upcoming_elections = @all_elections.select { |e| e.is_upcoming? }
    @finished_elections = @all_elections.select { |e| e.recently_finished? }
  end
end
