require 'spec_helper'

RSpec.describe Schedule do
  subject { Schedule.new }

  it { expect(subject.ranges).to eq([]) }

  describe '.add' do
    let(:schedule) { Schedule.new }

    subject { -> { schedule.add(range_from, range_to) } }

    context 'when beginning of range more then and' do
      let(:range_from) { 10 }
      let(:range_to) { 1 }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when range has negative numbers' do
      let(:range_from) { -1 }
      let(:range_to) { 10 }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when range is empty' do
      let(:range_from) { 10 }
      let(:range_to) { 10 }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when range is valid' do
      context 'and when ranges was empty' do
        let(:range_from) { 1 }
        let(:range_to) { 5 }

        it { is_expected.to change { schedule.ranges }.from([]).to([[1, 5]]) }
      end

      context 'and when ranges was not empty' do
        let(:range_from) { 5 }
        let(:range_to) { 15 }

        before do
          schedule.add(1, 2)
          schedule.add(4, 5)
          schedule.add(7, 9)
          schedule.add(10, 12)
          schedule.add(17, 22)
        end

        it { is_expected.to change { schedule.ranges }.to([[1, 2], [4, 15], [17, 22]]) }
      end
    end

    context 'when range already included' do
      let(:range_from) { 1 }
      let(:range_to) { 3 }

      before do
        schedule.add(1, 5)
        schedule.add(7, 9)
        schedule.add(13, 25)
        schedule.add(28, 30)
      end

      it { is_expected.not_to change { schedule.ranges } }
    end
  end

  describe '.remove' do
    let(:schedule) { Schedule.new }

    subject { -> { schedule.remove(range_from, range_to) } }

    before do
      schedule.add(1, 2)
      schedule.add(3, 5)
      schedule.add(6, 8)
    end

    context 'when beginning of range more then and' do
      let(:range_from) { 10 }
      let(:range_to) { 1 }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when range has negative numbers' do
      let(:range_from) { -1 }
      let(:range_to) { 10 }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when range is empty' do
      let(:range_from) { 10 }
      let(:range_to) { 10 }

      it { is_expected.to raise_error(ArgumentError) }
    end

    context 'when range is valid' do
      let(:range_from) { 4 }
      let(:range_to) { 7 }

      it {
        is_expected.to change { schedule.ranges }
          .from([[1, 2], [3, 5], [6, 8]])
          .to([[1, 2], [3, 4], [7, 8]])
      }
    end

    context 'when range already excluded' do
      let(:range_from) { 2 }
      let(:range_to) { 3 }

      it { is_expected.not_to change { schedule.ranges } }
    end
  end
end
