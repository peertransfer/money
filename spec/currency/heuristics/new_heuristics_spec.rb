require 'spec_helper'

describe Money::Currency::NewHeuristics::Tree do
  it 'return a hash of nodes for iso codes' do
    currencies = {
      aed: {
        iso_code: "AED",
        name: "United Arab Emirates Dirham",
      },
      afn: {
        iso_code: "AFN",
        name: "Afghan Afghani",
      }
    }

    expected_output = {
      "aed" => [{
        iso_code: "AED",
        name: "United Arab Emirates Dirham",
      }],
      "afn" => [{
        iso_code: "AFN",
        name: "Afghan Afghani",
      }]
    }

    tree = described_class.new(currencies)

    expect(tree.as_hash).to eq(expected_output)
  end

  it 'return a hash of nodes for symbols' do
    currencies = {
      aed: {
        name: "United Arab Emirates Dirham",
        symbol: "د.إ."
      },
      afn: {
        name: "Afghan Afghani",
        symbol: "؋"
      }
    }

    expected_output = {
      "د.إ" => [{
        name: "United Arab Emirates Dirham",
        symbol: "د.إ"
      }],
      "؋" => [{
        name: "Afghan Afghani",
        symbol: "؋"
      }]
    }

    tree = described_class.new(currencies)

    expect(tree.as_hash).to eq(expected_output)
  end
end