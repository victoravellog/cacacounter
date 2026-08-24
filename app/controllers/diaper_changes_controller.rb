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
      redirect_to request.referer || root_path, notice: "Cambio de pañal registrado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @diaper_change = DiaperChange.find(params[:id])
    @diaper_change.destroy
    redirect_to request.referer || diaper_changes_path, notice: "Registro eliminado."
  end

  private

  def diaper_change_params
    params.fetch(:diaper_change, {}).permit(:occurred_at, :size, :notes)
  end
end
