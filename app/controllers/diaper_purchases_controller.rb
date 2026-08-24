class DiaperPurchasesController < ApplicationController
  def index
    @diaper_purchases = DiaperPurchase.recent_first
  end

  def new
    @diaper_purchase = DiaperPurchase.new(purchased_at: Date.current, size: params[:size])
  end

  def create
    @diaper_purchase = DiaperPurchase.new(diaper_purchase_params)

    if @diaper_purchase.save
      redirect_to root_path, notice: "Compra registrada."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @diaper_purchase = DiaperPurchase.find(params[:id])
    @diaper_purchase.destroy
    redirect_to request.referer || diaper_purchases_path, notice: "Compra eliminada."
  end

  private

  def diaper_purchase_params
    params.require(:diaper_purchase).permit(:purchased_at, :size, :quantity, :brand, :notes)
  end
end
