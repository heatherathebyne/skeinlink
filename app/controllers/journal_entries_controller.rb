class JournalEntriesController < ApplicationController
  before_action :set_project
  def create
    @journal_entry = @project.journal_entries.new(journal_entry_params)

    if @journal_entry.save
      redirect_to @project, notice: 'Your journal entry was successfully created.'
    else
      redirect_to @project, alert: "We're sorry, but we couldn't create your journal entry."
    end
  end

  def update
  end

  def destroy
  end

  private

  def journal_entry_params
    params.require(:journal_entry).permit(:entry_timestamp, :content)
  end

  def set_project
    @project = current_user.projects.find(params[:journal_entry][:project_id])
  end
end
