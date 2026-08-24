require "rails_helper"

RSpec.describe DiaperPurchase do
  it "is valid with a known size, positive quantity and purchased_at" do
    purchase = described_class.new(purchased_at: Date.current, size: "M", quantity: 40)
    expect(purchase).to be_valid
  end

  it "is invalid with a zero or negative quantity" do
    purchase = described_class.new(purchased_at: Date.current, size: "M", quantity: 0)
    expect(purchase).not_to be_valid
  end

  it "is invalid with an unknown size" do
    purchase = described_class.new(purchased_at: Date.current, size: "NOT_A_SIZE", quantity: 10)
    expect(purchase).not_to be_valid
  end
end
