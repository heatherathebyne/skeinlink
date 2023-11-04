class PatternPatternPublisher < ApplicationRecord
  # I briefly considered PatternPublisherPattern,
  # but PatternPatternPublisher is funnier to say out loud

  audited

  has_one :pattern
  has_one :pattern_publisher
end
