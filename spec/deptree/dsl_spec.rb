describe Deptree::DSL do

  let(:host_class) {
    Class.new { extend Deptree::DSL }
  }

  it 'defines DSL for adding dependencies' do
    expect(host_class).to respond_to(:dependency)
  end

  it 'defines DSL for configuring dependencies' do
    expect(host_class).to respond_to(:configure)
  end

  describe 'adding a new dependency' do
    it 'allows to add a new dependency to the Registry' do
      host_class.dependency 'foo'

      expect(host_class.dependencies).to include 'foo'
    end
  end
end
