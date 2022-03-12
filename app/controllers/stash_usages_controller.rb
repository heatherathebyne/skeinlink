# This controller handles actions related to the StashUsage join model.
# Everything here should be scoped to the current user, and not used outside of the context of
# a user linking their own projects to their own stash.

class StashUsagesController < ApplicationController
  def create
    # The decision to .new rather than .find_or_initialize_by is deliberate. Creating duplicate
    # records is less surprising than updating an existing record.
    @stash_usage = StashUsage.new(stash_usage_params)

    authorize @stash_usage, :create?

    respond_to do |format|
      if @stash_usage.save
        format.html do
          redirect_back(fallback_location: stash_yarns_path, notice: 'Added yarn to project!')
        end

        format.json { render status: :ok, json: {} }
      else
        format.html do
          redirect_back(fallback_location: stash_yarns_path,
                        alert: "We're sorry, but we couldn't add that yarn to the project: #{@stash_usage.errors.full_messages}")
        end

        format.json { render status: :not_acceptable, json: { errors: @stash_usage.errors.full_messages } }
      end
    end
  end

  def destroy
    @stash_usage = StashUsage.find_by(project_id: stash_usage_params[:project_id],
                                      stash_yarn_id: stash_usage_params[:stash_yarn_id])

    return render status: :ok, json: {} unless @stash_usage

    authorize @stash_usage, :destroy?

    respond_to do |format|
      if @stash_usage.destroy
        format.html { redirect_back(fallback_location: stash_yarns_path, notice: 'Removed yarn from project!') }
        format.json { render status: :ok, json: {} }
      else
        format.html do
          redirect_back(fallback_location: stash_yarns_path,
                        alert: "We're sorry, but we couldn't remove that yarn from the project: #{@stash_usage.errors.full_messages}")
        end
        format.json do
          render status: :not_acceptable, json: { errors: @stash_usage.errors.full_messages }
        end
      end
    end
  end

  private

  def stash_usage_params
    params.require(:stash_usage).permit(:project_id, :stash_yarn_id, :yards_used)
  end
end
