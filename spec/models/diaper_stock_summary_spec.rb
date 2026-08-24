require "rails_helper"

RSpec.describe DiaperStockSummary do
  describe ".for_active_sizes" do
    it "only includes sizes with purchases or changes, ordered by DiaperSize::OPTIONS" do
      DiaperPurchase.create!(purchased_at: 3.days.ago.to_date, size: "M", quantity: 40)
      DiaperPurchase.create!(purchased_at: 10.days.ago.to_date, size: "G", quantity: 30)
      DiaperChange.create!(occurred_at: 2.hours.ago, size: "M")

      expect(described_class.for_active_sizes.map(&:size)).to eq(%w[M G])
    end
  end

  describe "#stock" do
    it "is purchased quantity minus number of changes for that size" do
      DiaperPurchase.create!(purchased_at: 3.days.ago.to_date, size: "M", quantity: 40)
      2.times { DiaperChange.create!(occurred_at: 2.hours.ago, size: "M") }

      expect(described_class.new(size: "M").stock).to eq(38)
    end
  end

  describe "#low_stock?" do
    it "is false for a size with plenty of stock and no usage" do
      DiaperPurchase.create!(purchased_at: 10.days.ago.to_date, size: "G", quantity: 30)

      expect(described_class.new(size: "G")).not_to be_low_stock
    end

    it "is true when usage exceeds stock, even with no recent history" do
      DiaperPurchase.create!(purchased_at: 30.days.ago.to_date, size: "P", quantity: 3)
      5.times { DiaperChange.create!(occurred_at: 20.days.ago, size: "P") }

      summary = described_class.new(size: "P")
      expect(summary.stock).to eq(-2)
      expect(summary).to be_low_stock
    end
  end
end
