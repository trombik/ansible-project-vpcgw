require_relative "../spec_helper"

describe service "strongswan" do
  it { should be_enabled }
  it { should be_running }
end

[500, 4500].each do |p|
  describe port p do
    it { should be_listening }
  end
end

describe command "ipfw nat show config" do
  its(:stderr) { should eq "" }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^ipfw nat 100 config if\s/) }
end

describe command "ipsec statusall" do
  its(:stderr) { should eq "" }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^Connections:\n\s+vpn:\s+%any\.\.\.%any\s+IKEv2/) }
  its(:stdout) { should match(/^\s+vpn:\s+local:\s+\[.*\] uses public key authentication$/) }
  its(:stdout) { should match(/^\s+vpn:\s+remote:\s+uses EAP_MSCHAPV2 authentication with EAP identity '%any'/) }
  its(:stdout) { should match(/^\s+vpn:\s+child:\s+#{Regexp.escape("0.0.0.0/0")} === dynamic TUNNEL, dpdaction=clear$/) }
end
