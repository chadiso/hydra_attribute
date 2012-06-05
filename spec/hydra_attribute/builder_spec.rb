require 'spec_helper'

describe HydraAttribute::Builder do

  let(:klass)    { Class.new }
  let!(:builder) { HydraAttribute::Builder.new(klass) }

  describe '#initialzie' do
    it 'should include HydraAttribute::ActiveRecord::Scoping to class' do
      klass.should include(HydraAttribute::ActiveRecord::Scoping)
    end

    it 'should include HydraAttribute::ActiveRecord::AttributeMethods to class' do
      klass.should include(HydraAttribute::ActiveRecord::AttributeMethods)
    end

    it 'should respond to all supported types' do
      HydraAttribute::SUPPORT_TYPES.each do |type|
        builder.should respond_to(type)
      end
    end
  end

  describe '#string' do
    let(:association_instance) { mock(:association_instance) }
    let(:attribute_instance)   { mock(:attribute_instance) }

    before do
      HydraAttribute::AssociationBuilder.should_receive(:new).with(klass, :string).and_return(association_instance)
      HydraAttribute::AttributeBuilder.should_receive(:new).with(klass, :name, :string).and_return(attribute_instance)

      [association_instance, attribute_instance].each { |instance| instance.should_receive(:build) }
    end

    it 'should build association' do
      builder.string :name
    end
  end
end