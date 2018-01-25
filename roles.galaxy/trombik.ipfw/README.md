# ansible-role-ipfw

Manage ipfw(8) rules.

Note that `/etc/rc.d/ipfw` does not support `status`. As such, the service is
always `started` by `ansible` even when the rules has not changed.

# Requirements

The host must have `ipfw` enabled by default. Otherwise, enabling any firewall
kills the ssh connection unless your firewall rule is _state-less_, which is
unlikely.

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ipfw_conf_file` | path to rule file written in `sh(1)` | `/etc/ipfw.conf` |
| `ipfw_extra_enables` | a list of extra `rc.conf(5)` variables | `["dummynet_enable", "firewall_nat_enable", "firewall_logif"]` |
| `ipfw_service` | Service name of `ipfw` | `ipfw` |
| `ipfw_rules` | Content of `ipfw_conf_file` | see below |

## `ipfw_rules`

```sh
fwcmd="/sbin/ipfw"
${fwcmd} -f flush
${fwcmd} add 65000 pass all from any to any
```

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-ipfw
  vars:
    ipfw_rules: |
      fwcmd="/sbin/ipfw"
      ${fwcmd} -f flush

      ${fwcmd} add 10000 deny all from any to 8.8.4.4
      ${fwcmd} add 65000 pass all from any to any
```

# License

```
Copyright (c) 2018 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
