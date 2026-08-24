class DiaperChange < ApplicationRecord
  validates :occurred_at, presence: true
  validates :size, presence: true, inclusion: { in: DiaperSize::OPTIONS }

  scope :for_size, ->(size) { where(size: size) }
  scope :recent_first, -> { order(occurred_at: :desc) }
  scope :since, ->(time) { where(occurred_at: time..) }
end
