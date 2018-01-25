require_relative "../spec_helper"

case test_environment
when "virtualbox"
  context "after provision finished" do
    all_hosts_in("virtualbox-f").each do |s|
      describe s do
        it "establishes VPN" do
          r = current_server.ssh_exec "sudo ipsec up vpn"
          expect(r).to match(/^connection 'vpn' established successfully/)
        end
      end
    end
  end

  context "when VPN connection is established" do
    all_hosts_in("virtualbox-f").each do |s|
      describe s do
        it "shows SA" do
          r = current_server.ssh_exec "sudo ipsec status"
          expect(r).to match(/^Security Associations \(1 up, 0 connecting\):$/)
        end

        it "shows modified default gateway" do
          r = current_server.ssh_exec "uname -s"
          case r.chomp
          when "FreeBSD"
            route = current_server.ssh_exec "route -n get 0.0.0.0/1"
            expect(route).to match(/^\s+interface: tun0$/)
            expect(route).to match(/^\s+flags: <UP/)
          end
        end
      end
    end

    all_hosts_in("gw").each do |s|
      describe s do
        it "shows SA" do
          r = current_server.ssh_exec("sudo ipsec status")
          expect(r).to match(/^Security Associations \(1 up, 0 connecting\):$/)
        end
      end
    end
  end
end
