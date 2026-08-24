class DashboardController < ApplicationController
  def index
    @summaries = DiaperStockSummary.for_active_sizes
    @sizes = DiaperSize::OPTIONS
    @recent_changes = DiaperChange.recent_first.limit(8)
  end
end
