describe Quickbooks::Util::Logging do
  before { Quickbooks.log = general_log_setting }
  let(:general_log_setting) { true }
  let(:dummy_class) { Class.new { include Quickbooks::Util::Logging } }

  describe 'log' do
    context 'when one service needs to log but general logging is disabled' do
      let(:general_log_setting) { false }
      let(:control_instance) { instance = dummy_class.new }
      let(:loggable_instance) do
        instance = dummy_class.new
        instance.log = true
        instance
      end

      it 'allows one service instance to log without affecting other service instances' do
        expect(Quickbooks.log?).to be(false)
        expect(control_instance.log?).to be(false)
        expect(loggable_instance.log?).to be(true)
      end

      it 'does not log if disabled' do
        expect(Quickbooks).not_to receive(:log)
        control_instance.log('test message')
      end

      it 'does log if enabled' do
        expect(Quickbooks).to receive(:log)
        loggable_instance.log('test message')
      end
    end

    context 'when one service needs to not log but general logging is enabled' do
      let(:control_instance) { instance = dummy_class.new }
      let(:unloggable_instance) do
        instance = dummy_class.new
        instance.log = false
        instance
      end

      it 'allows one service instance to log without affecting other service instances' do
        expect(Quickbooks.log?).to be(true)
        expect(control_instance.log?).to be(true)
        expect(unloggable_instance.log?).to be(false)
      end

      it 'does not log if disabled' do
        expect(Quickbooks).not_to receive(:log)
        unloggable_instance.log('test message')
      end

      it 'does log if enabled' do
        expect(Quickbooks).to receive(:log)
        control_instance.log('test message')
      end
    end
  end
end
