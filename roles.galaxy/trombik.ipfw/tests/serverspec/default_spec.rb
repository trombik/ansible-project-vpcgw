require "spec_helper"
require "serverspec"

service = "ipfw"
config  = "/etc/ipfw.conf"
default_user = "root"
default_group = "wheel"

describe file(config) do
  it { should exist }
  it { should be_file }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  it { should be_mode 600 }
  its(:content) { should match Regexp.escape("fwcmd=\"/sbin/ipfw\"") }
  its(:content) { should match Regexp.escape("${fwcmd} -f flush") }
  its(:content) { should match Regexp.escape("${fwcmd} add 65000 pass all from any to any") }
end

describe command "ifconfig ipfw0" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^ipfw0: flags=\d+<UP,/) }
end

%w[
  firewall_enable
  dummynet_enable
  firewall_nat_enable
  firewall_logif
].each do |i|
  describe file "/etc/rc.conf" do
    its(:content) { should match(/^#{Regexp.escape(i)}="YES"$/) }
  end
end

describe file "/etc/rc.conf" do
  its(:content) { should match(/^firewall_script="#{Regexp.escape(config)}"$/) }
end

%w[
  ipfw
  dummynet
  ipfw_nat
].each do |kmod|
  describe command "kldstat -n #{kmod}" do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match(/#{kmod}.ko/) }
  end
end

describe service(service) do
  it { should be_enabled }
end

describe command "ipfw show" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^10000\s+\d+\s+\d+\s+deny ip from any to 8\.8\.4\.4$/) }
  its(:stdout) { should match(/^65000\s+\d+\s+\d+\s+allow ip from any to any$/) }
end

describe command "drill example.org @8.8.8.8" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: \d+$/) }
end

describe command "drill example.org @8.8.4.4" do
  its(:exit_status) { should_not eq 0 }
  its(:stderr) { should match(/^Error: error sending query: Error creating socket$/) }
  its(:stdout) { should eq "" }
end
