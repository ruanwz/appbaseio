require 'spec_helper'
require 'vcr_helper'
require 'timecop'
describe Appbaseio::Client do
  before do
    Timecop.freeze(Time.utc(2015,2,6,7,12))
  end
  after do
    Timecop.return
  end
  options = {
    server_host:  'api.appbase.io',
    app_name: 'testapp',
    api_version: 'v2',
    namespace: 'test_api',
    app_secret: 'c1506ccb1db1ef61dc07f3546decf281'
  }
  subject {Appbaseio::Client.new(options)}
  it "accept parameters" do
    expect {subject}.to_not raise_error
  end
  it "can access the initialized parameters" do
    expect(subject.server_host).to eq options[:server_host]
  end
  it "list all vertex in the namespace" do

    VCR.use_cassette('list all vertex in a namespace') do
      resp = subject.list_list
      expect(resp.status).to be 200
      expect(resp.body).to be_a Array
    end
  end

  it "search vertices" do

  end

  it "create vertex" do
    VCR.use_cassette('create vertex') do
      resp = subject.create_properties vertex: 'abc', data: {foo: 'bar'}
      expect(resp.status).to be 200
      expect(resp.body).to be_a Hash
      expect(resp.body).to include "foo" => 'bar'
    end
  end

  it "read vertex" do
    VCR.use_cassette('read vertex') do
      subject.create_properties vertex: 'abc', data: {foo: 'bar'}
      resp = subject.read_properties vertex: 'abc'

      expect(resp.status).to be 200
      expect(resp.body).to be_a Hash
      expect(resp.body["vertex"]).to include "foo" => 'bar'
    end
  end

  it "delete vertex" do
    VCR.use_cassette('delete vertex') do
      subject.create_properties vertex: 'abc', data: {foo: 'bar'}
      resp = subject.delete_properties vertex: 'abc', data: ["foo"]

      expect(resp.status).to be 200
    end
  end

  it "create edges" do
    VCR.use_cassette('create edges') do
      subject.create_properties vertex: 'iron', data: {foo: 'bar'}
      subject.create_properties vertex: 'ice', data: {cat: 'dog'}

      resp = subject.create_edges vertex: 'ice', data: {anEdge: {path: "test_api/iron"}}
      expect(resp.status).to be 200
    end
  end

  it "read edges" do
    VCR.use_cassette('read edges') do
      subject.create_properties vertex: 'iron', data: {foo: 'bar'}
      subject.create_properties vertex: 'ice', data: {cat: 'dog'}
      subject.create_edges vertex: 'ice', data: {anEdge: {path: "test_api/iron"}}

      resp = subject.read_edges vertex: 'ice'
      expect(resp.status).to be 200
    end
  end

  it "delete edges" do
    VCR.use_cassette('delete edges') do
      subject.create_properties vertex: 'iron', data: {foo: 'bar'}
      subject.create_properties vertex: 'ice', data: {cat: 'dog'}
      subject.create_edges vertex: 'ice', data: {anEdge: {path: "test_api/iron"}}

      resp = subject.delete_edges vertex: 'ice', data: ["anEdge"]
      expect(resp.status).to be 200
    end
  end
end
