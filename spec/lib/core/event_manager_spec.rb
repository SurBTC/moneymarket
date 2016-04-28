require 'spec_helper'

describe Moneymarket::EventManager do
  let(:manager) { described_class.new }

  let(:foo) { Moneymarket::Event.new }
  let(:bar) { Moneymarket::Event.new }
  let(:baz) { Moneymarket::Event.new }

  describe "self.register" do
    it "should ignore events if called outside a capture block" do
      expect { described_class.register foo }.not_to raise_error
    end

    it "should nest events if events are generated inside given block" do
      described_class.register foo do
        described_class.register bar do
          described_class.register baz
        end
      end

      expect(foo.childs.first).to be bar
      expect(bar.childs.first).to be baz
    end
  end

  describe "capture" do
    it "should capture events registered globaly inside block" do
      manager.capture do
        described_class.register foo
        described_class.register bar
      end

      expect(manager.flush).to eq [foo, bar]
    end

    it "should fail if called nested within another capture call" do
      manager.capture do
        expect { manager.capture { } }.to raise_error
      end
    end
  end
end
