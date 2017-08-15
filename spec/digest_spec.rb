require 'spec_helper'
require 'digest'

describe 'digest' do

  it 'should get digest for candidates' do
    plots_list = SnowyOwl::Digest.generate_full_path_digest [{'plot_name' => 'sample'}]
    expect(plots_list).to match([a_hash_including('digest' => ::Digest::SHA1.hexdigest('sample'))])
  end
end
