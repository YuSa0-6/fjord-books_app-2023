# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioned_report, class_name: 'Report', inverse_of: :mentioning_mentions
  belongs_to :mentioning_report, class_name: 'Report', inverse_of: :mentioned_mentions

  validates :mentioning_report_id, uniqueness: { scope: :mentioned_report_id }
end
