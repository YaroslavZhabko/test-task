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

    context 'when new range starts before existing range starts and ends before existing range ends' do
      let(:range_from) { 7 }
      let(:range_to) { 13 }

      before do
        schedule.add(10, 15)
      end

      it {
        is_expected.to change { schedule.ranges }
          .from([[10, 15]])
          .to([[7, 15]])
      }
    end

    context 'when new range starts before existing range starts and ends after existing range ends' do
      let(:range_from) { 7 }
      let(:range_to) { 16 }

      before do
        schedule.add(10, 15)
        schedule.add(20, 25)
      end

      it {
        is_expected.to change { schedule.ranges }
          .from([[10, 15], [20, 25]])
          .to([[7, 16], [20, 25]])
      }
    end

    context 'when new range starts before some existing range starts and ends after few existing range ends' do
      let(:range_from) { 11 }
      let(:range_to) { 20 }

      before do
        schedule.add(10, 15)
        schedule.add(17, 19)
        schedule.add(20, 25)
        schedule.add(30, 45)
      end

      it {
        is_expected.to change { schedule.ranges }
          .from([[10, 15], [17, 19], [20, 25], [30, 45]])
          .to([[10, 25], [30, 45]])
      }
    end

    context 'when new range starts and ends before existing range' do
      let(:range_from) { 5 }
      let(:range_to) { 9 }

      before do
        schedule.add(10, 15)
      end

      it {
        is_expected.to change { schedule.ranges }
          .from([[10, 15]])
          .to([[5, 9], [10, 15]])
      }
    end

    context 'when new range starts and ends after existing ranges' do
      let(:range_from) { 24 }
      let(:range_to) { 25 }

      before do
        schedule.add(10, 15)
        schedule.add(20, 23)
      end

      it {
        is_expected.to change { schedule.ranges }
          .from([[10, 15], [20, 23]])
          .to([[10, 15], [20, 23], [24, 25]])
      }
    end

    context 'when new range fill empty gap' do
      let(:range_from) { 24 }
      let(:range_to) { 26 }

      before do
        schedule.add(10, 24)
        schedule.add(26, 30)
      end

      it {
        is_expected.to change { schedule.ranges }
          .from([[10, 24], [26, 30]])
          .to([[10, 30]])
      }
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
    let(:range1_from) { 1 }
    let(:range1_to) { 2 }
    let(:range2_from) { 3 }
    let(:range2_to) { 10 }
    let(:range3_from) { 14 }
    let(:range3_to) { 20 }
    let!(:initial_state) { [[range1_from, range1_to], [range2_from, range2_to], [range3_from, range3_to]] }

    subject { -> { schedule.remove(range_from, range_to) } }

    before do
      schedule.add(range1_from, range1_to)
      schedule.add(range2_from, range2_to)
      schedule.add(range3_from, range3_to)
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

    context 'when range for remove starts before existing range starts and ends before existing range ends' do
      let(:range_from) { 2 }
      let(:range_to) { 4 }

      it {
        is_expected.to change { schedule.ranges }
          .from(initial_state)
          .to([[1, 2], [4, 10], [14, 20]])
      }
    end

    context 'when range for remove starts before existing range starts and ends after existing range ends' do
      let(:range_from) { 0 }
      let(:range_to) { 3 }

      it {
        is_expected.to change { schedule.ranges }
          .from(initial_state)
          .to([[3, 10], [14, 20]])
      }
    end

    context 'when range for remove starts after existing range starts and ends after existing range ends' do
      let(:range_from) { 15 }
      let(:range_to) { 21 }

      it {
        is_expected.to change { schedule.ranges }
          .from(initial_state)
          .to([[1, 2], [3, 10], [14, 15]])
      }
    end

    context 'when range for remove starts before some existing range starts and ends after few existing range ends' do
      let(:range_from) { 0 }
      let(:range_to) { 12 }

      it {
        is_expected.to change { schedule.ranges }
          .from(initial_state)
          .to([[14, 20]])
      }
    end

    context 'when range for remove starts after existing range starts and ends before existing range ends' do
      let(:range_from) { 15 }
      let(:range_to) { 19 }

      it {
        is_expected.to change { schedule.ranges }
          .from(initial_state)
          .to([[1, 2], [3, 10], [14, 15], [19, 20]])
      }
    end

    context 'when range already excluded' do
      let(:range_from) { 2 }
      let(:range_to) { 3 }

      it { is_expected.not_to change { schedule.ranges } }
    end
  end
end
