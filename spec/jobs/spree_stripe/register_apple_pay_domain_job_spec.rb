require 'spec_helper'

RSpec.describe SpreeStripe::RegisterDomainJob do
  subject { described_class.new.perform(model_id, model_type) }

  let(:register_domain_service) { double(:register_domain_service, call: nil) }

  before do
    allow(SpreeStripe::RegisterDomain).to receive(:new).and_return(register_domain_service)
  end

  context 'when the model is a store' do
    let(:model_id) { store.id }
    let(:model_type) { 'store' }
    let(:store) { create(:store) }

    it 'calls SpreeStripe::RegisterDomain' do
      subject
      expect(register_domain_service).to have_received(:call).with(model: store)
    end
  end
end
