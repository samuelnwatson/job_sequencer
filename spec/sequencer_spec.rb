require 'spec_helper'
require_relative '../sequencer'

RSpec.describe 'sequencer' do
  describe '.call' do
    subject do
      Sequencer.new
    end

    context "with valid input" do
      it "returns a job list unaltered if no dependencies" do
        args = "a => b => c => d => "
        expect(subject.call(args)).to eq "abcd"
      end

      it "returns a job list from string" do
        args = "b => c a =>  c =>  d => a"
        expect(subject.call(args)).to eq "acdb"
      end

      it "returns a job list from hash" do
        args = {'a' => '',  'b' => 'c', 'c' => '', 'd' => 'a'}
        expect(subject.call(args)).to eq "acdb"
      end
    end

    context "with invalid input" do
      it "recognises a circular dependency" do
        args = "t => r r => t"
        expect(subject.call(args)).to eq "Cannot have circular job dependencies"
      end

      it "flags jobs that reference themselves" do
        args = "y => z z => z"
        expect(subject.call(args)).to eq "Cannot have jobs refer to themselves"
      end

      it "returns empty string if given empty job list" do
        expect(subject.call('')).to eq ""
        expect(subject.call({})).to eq ""
      end

      it "flags invalid input" do
        expect(subject.call([])).to eq 'Invalid args given: []'
      end
    end
  end
end
