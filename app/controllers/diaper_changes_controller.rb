class DiaperChangesController < ApplicationController
  def index
    @diaper_changes = DiaperChange.recent_first
  end

  def new
    @diaper_change = DiaperChange.new(occurred_at: Time.current, size: params[:size])
  end

  def create
    @diaper_change = DiaperChange.new(diaper_change_params)
    @diaper_change.occurred_at ||= Time.current

    if @diaper_change.save
      respond_to do |format|
        format.turbo_stream { render_dashboard_updates } if from_dashboard?
        format.html { redirect_to root_path, notice: "Cambio de pañal registrado." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @diaper_change = DiaperChange.find(params[:id])
    @diaper_change.destroy

    respond_to do |format|
      format.turbo_stream { render_dashboard_updates }
      format.html { redirect_to request.referer || diaper_changes_path, notice: "Registro eliminado." }
    end
  end

  private

  def diaper_change_params
    params.fetch(:diaper_change, {}).permit(:occurred_at, :size, :notes)
  end

  def from_dashboard?
    request.referer.present? && URI.parse(request.referer).path == "/"
  end

  def render_dashboard_updates
    @summaries = DiaperStockSummary.for_active_sizes
    @recent_changes = DiaperChange.recent_first.limit(8)

    render turbo_stream: [
      turbo_stream.replace("stock_grid", partial: "dashboard/stock_grid", locals: { summaries: @summaries }),
      turbo_stream.replace("recent_activity", partial: "dashboard/recent_activity", locals: { recent_changes: @recent_changes })
    ]
  end
end
