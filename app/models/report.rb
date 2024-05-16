# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_mentions, class_name: 'Mention', foreign_key: :mentioning_report_id, dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :mentioning_mentions, source: :mentioned_report

  has_many :mentioned_mentions, class_name: 'Mention', foreign_key: :mentioned_report_id, dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioned_reports, through: :mentioned_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  after_save :update_mentions

  def editable?(target_user)
    user == target_user
  end

  def other_report?(uri_id)
    uri_id.to_i != id.to_i
  end

  def created_on
    created_at.to_date
  end

  def update_mentions
    uri_ids = extract_uri_ids
    delete_mentions
    save_mentions(uri_ids)
  end

  def save_mentions(uri_ids)
    uri_ids.each do |uri_id|
      next unless other_report?(uri_id)

      Mention.new(mentioned_report_id: uri_id, mentioning_report_id: id).save
    end
  end

  def delete_mentions
    Mention.where(mentioning_report_id: id).find_each(&:destroy)
  end

  def extract_uri_ids
    uris = URI.extract(content)
    uris.map do |uri|
      uri.match(%r{reports/(\d+)$}).captures.first
    rescue StandardError
      nil
    end
  end
end
