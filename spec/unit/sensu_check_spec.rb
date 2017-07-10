require 'spec_helper'

describe Puppet::Type.type(:sensu_check) do
  let(:resource_hash) do
    {
      :title => 'foo.example.com',
      :catalog => Puppet::Resource::Catalog.new
    }
  end

  describe 'handlers' do
    it 'should support a string as a value' do
      expect(
        described_class.new(resource_hash.merge(:handlers => 'default'))[:handlers]
      ).to eq ['default']
    end

    it 'should support an array as a value' do
      expect(
        described_class.new(
          resource_hash.merge(:handlers => %w(handler1 handler2))
        )[:handlers]
      ).to eq %w(handler1 handler2)
    end

    # it 'should support nil as a value' do
    #   expect(
    #     described_class.new(
    #       resource_hash.merge(:handlers => nil)
    #     )[:handlers]
    #   ).to eq nil
    # end
  end

  describe 'subscribers' do
    it 'should support a string as a value' do
      expect(
        described_class.new(resource_hash.merge(:subscribers => 'default'))[:subscribers]
      ).to eq ['default']
    end

    it 'should support an array as a value' do
      expect(
        described_class.new(
          resource_hash.merge(:subscribers => %w(subscriber1 subscriber2))
        )[:subscribers]
      ).to eq %w(subscriber1 subscriber2)
    end

    # it 'should support nil as a value' do
    #   expect(
    #     described_class.new(
    #       resource_hash.merge(:subscribers => nil)
    #     )[:subscribers]
    #   ).to eq nil
    # end
  end

  describe 'notifications' do
    context 'when managing sensu-enterprise (#495)' do
      let(:service_resource) do
        Puppet::Type.type(:service).new(name: 'sensu-enterprise')
      end
      let(:resource_hash) do
        c = Puppet::Resource::Catalog.new
        c.add_resource(service_resource)
        {
          :title => 'foo.example.com',
          :catalog => c
        }
      end

      it 'notifies Service[sensu-enterprise]' do
        notify_list = described_class.new(resource_hash)[:notify]
        # compare the resource reference strings, the object identities differ.
        expect(notify_list.map(&:ref)).to eq [service_resource.ref]
      end
    end
  end
end
