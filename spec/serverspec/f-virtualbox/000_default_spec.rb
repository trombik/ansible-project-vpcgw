require_relative "../spec_helper"

describe command "ipspec statusall" do
  its(:stderr) { should eq "" }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^Connections:\n\s+vpn:\s+%any#{Regexp.escape("...vpn.test.trombik.org")}\s+IKEv2$/) }
  its(:stdout) { should match(/^\s+vpn:\s+local:\s+uses EAP_MSCHAPV2 authentication with EAP identity/) }
  its(:stdout) { should match(/^\s+vpn:\s+child:\s+dynamic === #{Regexp.escape("0.0.0.0/0")} TUNNEL$/) }
end
