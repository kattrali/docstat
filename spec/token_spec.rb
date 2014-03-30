$:.unshift File.expand_path('../../lib', __FILE__)

require 'bacon'
require 'docstat/token'

describe 'Token' do

  describe 'to_hash' do
    before do
      @token = DocStat::Token.new(['SomeClass','save:','instfm','saves the state','-(void)save:(NSError**)error'])
      @hash = @token.to_hash
    end

    it "includes the name" do
      @hash['name'].should.equal @token.name
    end

    it "includes the type" do
      @hash['type'].should.equal @token.pretty_type
    end

    it "includes the abstract" do
      @hash['abstract'].should.equal @token.abstract
    end

    it "includes the token declaration" do
      @hash['declaration'].should.equal @token.declaration
    end
  end

  describe "method?" do

    describe "instance category method" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','intfm','saves the state','-(void)save:(NSError**)error'])
      end

      it "is true" do
        @token.method?.should.equal true
      end
    end

    describe "class category method" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','clfm','saves the state','-(void)save:(NSError**)error'])
      end

      it "is true" do
        @token.method?.should.equal true
      end
    end

    describe "instance method" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','instm','saves the state','-(void)save:(NSError**)error'])
      end

      it "is true" do
        @token.method?.should.equal true
      end
    end

    describe "class method" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','clm','saves the state','-(void)save:(NSError**)error'])
      end

      it "is true" do
        @token.method?.should.equal true
      end
    end

    describe "property" do
      before do
        @token = DocStat::Token.new(['SomeClass','saved','instp','state is saved','@property (nonatomic, getter = isSaved) BOOL saved'])
      end

      it "is false" do
        @token.method?.should.equal false
      end
    end

    describe "category property" do
      before do
        @token = DocStat::Token.new(['SomeClass','saved','intfp','state is saved','@property (nonatomic, getter = isSaved) BOOL saved',''])
      end

      it "is false" do
        @token.method?.should.equal false
      end
    end
  end

  describe "documented?" do
    describe "abstract length > 0 and return value length = 0" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','instfm','saves the state','-(void)save:(NSError**)error',''])
      end

      it "is true" do
        @token.documented?.should.equal true
      end
    end

    describe "return value length > 0 and abstract length = 0" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','instfm','','-(void)save:(NSError**)error','nothing!'])
      end

      it "is true" do
        @token.documented?.should.equal true
      end
    end

    describe "return value length > 0 and abstract length > 0" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','instfm','saves the state','-(void)save:(NSError**)error','nothing!'])
      end

      it "is true" do
        @token.documented?.should.equal true
      end
    end

    describe "abstract length = 0 and return value length = 0" do
      before do
        @token = DocStat::Token.new(['SomeClass','save:','instfm','','-(void)save:(NSError**)error',''])
      end

      it "is false" do
        @token.documented?.should.equal false
      end
    end
  end
end