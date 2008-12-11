require 'spec/spec_helper'

describe 'Hash Extensions' do
  it "should add methods for hash string keys" do
    entry = {'apple' => 'pie'}.add_hash_keys_as_methods
    entry.apple.should eql('pie')
  end
end