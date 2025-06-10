require 'spec_helper'

RSpec.describe SpreeStripe::RegisterDomain do
  subject(:register_domain) { described_class.new.call(model: model) }

  let(:store) { create(:store) }
  let!(:stripe_gateway) { create(:stripe_gateway, stores: [store]) }

  let(:payment_method_domain) do
    Stripe::PaymentMethodDomain.list({ domain_name: domain }, stripe_gateway.api_options).data.find do |s_domain|
      s_domain.domain_name == domain
    end
  end
  let(:apple_pay_top_level_domain) do
    Stripe::PaymentMethodDomain.list({ domain_name: tld_domain }, stripe_gateway.api_options).data.find do |domain|
      domain.domain_name == tld_domain
    end
  end

  context 'for store' do
    let(:model) { store }
    let(:domain) { model.url }

    before do
      allow(model).to receive(:url).and_return('dare-gerhold-and-pagac.lvh.me')
    end

    it 'register only store domain', :vcr do
      expect(Stripe::PaymentMethodDomain).to receive(:create).once.with({ domain_name: domain }).and_call_original
      register_domain

      expect(payment_method_domain).to be_present
      expect(model.stripe_apple_pay_domain_id).to eq(payment_method_domain.id)
    end
  end
end
