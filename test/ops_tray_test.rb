require 'ops_tray'
require 'icon_pack'
require "test_helper"

module Opswatch
  class OpsTrayTest < MiniTest::Test
    def setup
      @icons = IconPack.new('Test')
      @opstray = OpsTray.new('Test', @icons)
    end

    def test_compute_status
      resp = { online: 2, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: "successful" }
      assert_equal 'ONLINE', @opstray.send(:compute_status, resp)

      resp = { online: 2, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: "failed" }
      assert_equal 'FAILED', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: 1, start_failed: nil, deploy_state: "succesful" }
      assert_equal 'FAILED', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: nil, start_failed: 1, deploy_state: "succesful" }
      assert_equal 'FAILED', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: 1, start_failed: nil, deploy_state: "failed" }
      assert_equal 'FAILED', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: nil, start_failed: 1, deploy_state: "failed" }
      assert_equal 'FAILED', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: "succesful" }
      assert_equal 'OFFLINE', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: "failed" }
      assert_equal 'OFFLINE', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: nil }
      assert_equal 'OFFLINE', @opstray.send(:compute_status, resp)

      resp = {}
      assert_equal 'OFFLINE', @opstray.send(:compute_status, resp)

      resp = { online: 1, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: "running" }
      assert_equal 'DEPLOYING', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: 1, setup_failed: nil, start_failed: nil, deploy_state: "running" }
      assert_equal 'DEPLOYING', @opstray.send(:compute_status, resp)

      resp = { online: nil, running_setup: nil, setup_failed: nil, start_failed: nil, deploy_state: nil, exception: true }
      assert_equal 'INVALID_STATE', @opstray.send(:compute_status, resp)
    end
  end
end
