# This controller handles actions related to the StashUsage join model.
# Everything here should be scoped to the current user, and not used outside of the context of
# a user linking their own projects to their own stash.

class StashUsagesController < ApplicationController
  def create
    @stash_usage = StashUsage.find_or_initialize_by(project_id: stash_usage_params[:project_id],
                                                    stash_yarn_id: stash_usage_params[:stash_yarn_id])
    @stash_usage.yards_used = stash_usage_params[:yards_used]

    authorize @stash_usage, :create?

    if @stash_usage.save
      render status: :ok, json: {}
    else
      render status: :not_acceptable, json: { errors: @stash_usage.errors.full_messages }
    end
  end

  def destroy
    @stash_usage = StashUsage.find_by(project_id: stash_usage_params[:project_id],
                                      stash_yarn_id: stash_usage_params[:stash_yarn_id])
   # binding.pry

    return render status: :ok, json: {} unless @stash_usage

    authorize @stash_usage, :destroy?

    if @stash_usage.destroy
      render status: :ok, json: {}
    else
      render status: :not_acceptable, json: { errors: @stash_usage.errors.full_messages }
    end
  end

  private

  def stash_usage_params
    params.require(:stash_usage).permit(:project_id, :stash_yarn_id, :yards_used)
  end
end
