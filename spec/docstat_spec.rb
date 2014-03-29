require 'bacon'
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/docstat'))

describe 'DocStat' do
  SAMPLE_PATH = File.expand_path(File.join(File.dirname(__FILE__), './fixtures/sample.docset'))

  describe "process" do
    before do
      @stats = DocStat.process(SAMPLE_PATH)
    end

    it "parses a docset into hashes" do
      @stats['containers'].detect {|t| !t.kind_of?(Hash) }.should.equal nil
    end
  end

  describe 'Container' do
    before do
      @container = Container.new('SomeClass', [
        ['SomeClass','walk:','instfm','saves the state','-(void)walk:(NSError**)error'],
        ['SomeClass','run:','instfm','','-(void)run:(NSError**)error'],
        ['OtherClass','fly:','instfm',nil,'-(void)fly:(NSError**)error'],
        ['SomeClass','sink:','instfm','','-(void)sink:(NSError**)error']])
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

  describe 'Token' do

    describe 'to_hash' do
      before do
        @token = Token.new(['SomeClass','save:','instfm','saves the state','-(void)save:(NSError**)error'])
        @hash = @token.to_hash
      end

      it "includes the name" do
        @hash['name'].should.equal @token.name
      end

      it "includes the type" do
        @hash['type'].should.equal @token.type
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
          @token = Token.new(['SomeClass','save:','instfm','saves the state','-(void)save:(NSError**)error'])
        end

        it "is true" do
          @token.method?.should.equal true
        end
      end

      describe "class category method" do
        before do
          @token = Token.new(['SomeClass','save:','clfm','saves the state','-(void)save:(NSError**)error'])
        end

        it "is true" do
          @token.method?.should.equal true
        end
      end

      describe "instance method" do
        before do
          @token = Token.new(['SomeClass','save:','instm','saves the state','-(void)save:(NSError**)error'])
        end

        it "is true" do
          @token.method?.should.equal true
        end
      end

      describe "class method" do
        before do
          @token = Token.new(['SomeClass','save:','clm','saves the state','-(void)save:(NSError**)error'])
        end

        it "is true" do
          @token.method?.should.equal true
        end
      end

      describe "property" do
        before do
          @token = Token.new(['SomeClass','saved','instp','state is saved','@property (nonatomic, getter = isSaved) BOOL saved'])
        end

        it "is false" do
          @token.method?.should.equal false
        end
      end

      describe "category property" do
        before do
          @token = Token.new(['SomeClass','saved','instfp','state is saved','@property (nonatomic, getter = isSaved) BOOL saved'])
        end

        it "is false" do
          @token.method?.should.equal false
        end
      end
    end

    describe "documented?" do
      describe "abstract length > 0" do
        before do
          @token = Token.new(['SomeClass','save:','instfm','saves the state','-(void)save:(NSError**)error'])
        end

        it "is true" do
          @token.documented?.should.equal true
        end
      end

      describe "abstract length = 0" do
        before do
          @token = Token.new(['SomeClass','save:','instfm','','-(void)save:(NSError**)error'])
        end

        it "is false" do
          @token.documented?.should.equal false
        end
      end
    end
  end
end