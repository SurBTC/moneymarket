require 'pry'
require 'moneymarket'
require 'fileutils'

SPEC_HELPER_PATH = File.expand_path("../support", __FILE__)
SPEC_FIX_PATH = File.expand_path("../fixtures", __FILE__)
SPEC_TMP_PATH = File.expand_path("../tmp", __FILE__)

Dir[File.join(SPEC_HELPER_PATH, "/*.rb")].each { |f| require f }

include Helpers

RSpec.configure do |config|
  config.after do
    FileUtils.rm_r Dir.glob File.join(SPEC_TMP_PATH, '*.*')
  end
end