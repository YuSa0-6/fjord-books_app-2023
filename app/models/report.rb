# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentions, class_name: 'Mention', foreign_key: :mentioned_report_id, dependent: :destroy,
                           inverse_of: :mentioned_report
  has_many :passive_mentions, class_name: 'Mention', foreign_key: :mentioning_report_id, dependent: :destroy,
                         inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :active_mentions, source: :mentioning_report
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  after_save :save_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def save_mentions
    uri_ids = extract_uri_ids
    mentioned_reports.destroy_all
    create_mentions(uri_ids)
  end

  def create_mentions(uri_ids)
    transaction do
      uri_ids.each do |uri_id|
        next if uri_id.to_i == id

        mentions_from.new(mentioning_report_id: uri_id).save!
      end
    end
  end

  def extract_uri_ids
    uris = URI.extract(content)
    uris.map do |uri|
      uri.match(%r{http://localhost:3000/reports/(\d+)$}).captures.first
    end
  end
end
