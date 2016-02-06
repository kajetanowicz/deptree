describe Deptree::DSL do

  let(:host_class) {
    Class.new { extend Deptree::DSL }
  }

  it 'adds DSL for defining dependencies' do
    expect(host_class).to respond_to(:dependency)
  end

  describe 'adding a new dependency' do
    it 'allows to add a new dependency to the Registry' do
      host_class.dependency 'foo'

      expect(host_class.dependencies).to include :foo
    end
  end
end
