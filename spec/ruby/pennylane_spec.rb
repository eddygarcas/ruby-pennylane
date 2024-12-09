# frozen_string_literal: true

RSpec.describe Ruby::Pennylane do
  it "has a version number" do
    expect(Ruby::Pennylane::VERSION).not_to be nil
  end

  it "will get all the VAT rates" do
    resp = Ruby::Pennylane::Client.new(token: "fdljeTxUnWeV-Zg3PgooyGaN6yrM6JmcbBB26YJO--Y").call(element: :enums, id: :vat_rate, locale: :en, method: :get)
    JSON.parse(resp.body).each do |rate|
      expect(rate["value"]).to_not be_nil
      expect(rate["label"]).to_not be_nil
    end
  end

end
