module SpreeStripe
  class RegisterDomainJob < BaseJob
    def perform(model_id, klass_type = 'store')
      @klass_type = klass_type
      model = klass.find(model_id)
      RegisterDomain.new.call(model: model)
    end

    private

    def klass
      Spree::Store
    end
  end
end
