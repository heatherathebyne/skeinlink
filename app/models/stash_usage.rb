class StashUsage < ApplicationRecord
  belongs_to :project
  belongs_to :stash_yarn
end
