# frozen_string_literal: true

RSpec.describe Rz::Pennylane do
  it "has a version number" do
    expect(Rz::Pennylane::VERSION).not_to be nil
  end

  it "will get all the VAT rates" do
    resp = Rz::Pennylane::Client.new(token: "lqS6dUWwCXETdK3h3I3fypaQL3BV3R4Iye_TYEOG4lc").call(element: :enums, id: :vat_rate, locale: :en, method: :get)
    JSON.parse(resp.body).each do |rate|
      expect(rate["value"]).to_not be_nil
      expect(rate["label"]).to_not be_nil
    end
  end

end
