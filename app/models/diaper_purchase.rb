class DiaperPurchase < ApplicationRecord
  validates :purchased_at, presence: true
  validates :size, presence: true, inclusion: { in: DiaperSize::OPTIONS }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :for_size, ->(size) { where(size: size) }
  scope :recent_first, -> { order(purchased_at: :desc) }
end
