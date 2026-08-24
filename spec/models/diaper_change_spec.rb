require "rails_helper"

RSpec.describe DiaperChange do
  it "is valid with a known size and occurred_at" do
    change = described_class.new(occurred_at: Time.current, size: "M")
    expect(change).to be_valid
  end

  it "is invalid without occurred_at" do
    change = described_class.new(size: "M")
    expect(change).not_to be_valid
  end

  it "is invalid with an unknown size" do
    change = described_class.new(occurred_at: Time.current, size: "NOT_A_SIZE")
    expect(change).not_to be_valid
  end
end
