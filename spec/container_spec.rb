$:.unshift File.expand_path('../../lib', __FILE__)

require 'bacon'
require 'pretty_bacon'
require 'docstat/container'

describe 'Container' do
  before do
    @container = DocStat::Container.new('SomeClass', [
      ['SomeClass','walk:','instfm','saves the state','-(void)walk:(NSError**)error'],
      ['SomeClass','counter','instp','','@property (nonatomic, strong) NSNumber *counter'],
      ['OtherClass','fly:','instfm',nil,'-(void)fly:(NSError**)error'],
      ['ThirdClass','sink:','instfm','','-(void)sink:(NSError**)error']])
  end

  describe 'to_hash' do
    before do
      @hash = @container.to_hash
    end

    it "includes the container name" do
      @hash['name'].should.equal @container.name
    end

    it "lists the container's tokens" do
      @hash['tokens'].class.should.equal Array
    end

    it "includes documentation ratio" do
      @hash['ratio'].should.equal @container.ratio
    end
  end

  describe 'ratio' do
    it "shows overall documentation coverage ratio" do
      @container.ratio.should.equal 0.25
    end
  end
end
