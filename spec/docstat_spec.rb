$:.unshift File.expand_path('../../lib', __FILE__)

require 'bacon'
require 'pretty_bacon'
require 'docstat'

describe 'DocStat' do
  SAMPLE_PATH = File.expand_path(File.join(File.dirname(__FILE__), './fixtures/sample.docset'))

  describe "process" do
    before do
      @stats = DocStat.process(SAMPLE_PATH)
    end

    it "parses a docset into hashes" do
      @stats['containers'].size.should.not.equal 0
    end

    it "includes the overall documentation ratio" do
      @stats['ratio'].should.not.equal nil
    end
  end
end
