# frozen_string_literal: true

class Mention < ApplicationRecord
  # この言及元(mentioned_reports)は日報に対して一つだから
  belongs_to :mentioned_report, class_name: 'Report', inverse_of: :mentioning_mentions
  # この言及先(mentioning_reports)は日報に対して１つだから
  belongs_to :mentioning_report, class_name: 'Report', inverse_of: :mentioned_mentions

  validates :mentioning_report_id, uniqueness: { scope: :mentioned_report_id, message: 'has already mentioned report' }
end
