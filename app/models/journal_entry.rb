class JournalEntry < ApplicationRecord
  audited

  belongs_to :project
end
