class DiaperStockSummary
  TRACKING_WINDOW_DAYS = 14
  LOW_STOCK_DAYS_THRESHOLD = 3

  attr_reader :size, :purchased, :used, :stock, :avg_daily_usage, :estimated_days_left

  def self.for_active_sizes
    sizes_in_use = (DiaperPurchase.distinct.pluck(:size) + DiaperChange.distinct.pluck(:size)).uniq
    DiaperSize::OPTIONS.select { |size| sizes_in_use.include?(size) }.map { |size| new(size: size) }
  end

  def initialize(size:)
    @size = size
    @purchased = DiaperPurchase.for_size(size).sum(:quantity)
    @used = DiaperChange.for_size(size).count
    @stock = purchased - used
    @avg_daily_usage = compute_avg_daily_usage
    @estimated_days_left = avg_daily_usage.positive? ? (stock / avg_daily_usage).round(1) : nil
  end

  def low_stock?
    stock <= 0 || (estimated_days_left && estimated_days_left <= LOW_STOCK_DAYS_THRESHOLD)
  end

  private

  def compute_avg_daily_usage
    window_start = TRACKING_WINDOW_DAYS.days.ago.beginning_of_day
    recent_changes = DiaperChange.for_size(size).since(window_start)
    recent_count = recent_changes.count
    return 0.0 if recent_count.zero?

    earliest = recent_changes.minimum(:occurred_at)
    days_tracked = [ ((Time.current.to_date - earliest.to_date).to_i + 1), TRACKING_WINDOW_DAYS ].min
    recent_count.to_f / days_tracked
  end
end
