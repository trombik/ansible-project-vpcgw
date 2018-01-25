# README for projects

This README describes directory structure, procedures, operations, and
interfaces, commonly used by projects.

## Install

* `vagrant`
* `virtualbox`
* `bundler`
* `terraform`
* `ansible`

## Creating password file for `ansible-vault`

By default, it is assumed that a password file, `~/.project.vault` exists for
encryption. Create it. See [Ansible
Vault](https://docs.ansible.com/ansible/latest/vault.html) for details.

```
bundle install --path ~/.bundle/vendor
```

## `terraform`

Some AMIs needs agreement to EULA before use. Accept the EULA if any of AMI in
the project require it.

* the official FreeBSD AMI https://aws.amazon.com/marketplace/fulfillment?productId=bc4e6908-719b-4c0d-bab6-d5e6a707dbe3&ref_=dtl_psb_continue

See files under `terraform/plans/staging` for AMI IDs.

### Initializing `terraform`

Before using `terraform`, you need to initialize `terraform`.

```
terraform init terraform/plans/staging
terraform get terraform/plans/staging
```

After that, regular `terraform` commands should work, such as:

```
terraform plan terraform/plans/staging
terraform apply terraform/plans/staging
```

# The `Rakefile`

The `Rakefile` integrates `ansible` inventories, VM creation and management,
tests, and provides common interfaces to different back-ends.

## Environment

An environment is where VMs are created. There are three environments:
`virtualbox`, `staging`, and `prod`. The `virtualbox` environment uses
`virtualbox` and `vagrant` as back-ends. The `staging` and `prod` use AWS EC2
and `terraform`.

To switch to one environment from another, set `ANSIBLE_ENVIRONMENT`
environment variable to the environment name. If the variable is not set, the
default environment is `virtualbox`.

Each target performs same operation in different environments. For example,
`rake up` launches VMs and `rake clean` destroy all resources in the
environment.

## Launching VMs

To launch VMs, use `up` target. This target launch VMs. Unlike `vagrant up`,
the command does not perform provision.

```
bundle exec rake up
```

## Provisioning

To provision the VMs, use `provision` target. The target provisions VMs with
`ansible`.

```
bundle exec rake provision
```

## Testing

### non-destructive tests and destructive tests

Non-destructive tests do not change the state of an environment.

* MUST NOT modify files, records, or resources
* MUST NOT stop or restart daemons
* MUST output consistent results
* MAY create logging records in logs
* SHOULD output consistent results after destructive tests

Destructive tests may, and usually will, change the status of an environment.

* MAY output inconsistent results in each test (a result of test after another
  may differ)
* MAY modify files, records, or resources
* MAY stop or restart daemons
* SHOULD restore original state for non-destructive tests

#### Running non-destructive tests

Non-destructive tests are under `spec/serverspec`. To run the tests:

```
bundle exec rake test:serverspec:all
```

#### Running destructive tests

Destructive tests are under `spec/integration`. To run the tests:

```
bundle exec rake test:integration:all
```

### Run all tests

To test an environment from scratch, use `test` target. It assumes the
environment has not been created. The target does NOT clean up the
environment after execution.

```
bundle exec rake test
```

### Destroying

To destroy all resources in an environment, use `clean`. This destroys _all
resources_ in the environment.

```
bundle exec rake clean
```

### Showing the status

To show the status of an environment, use `status` target. The output is
environment-dependent, i.e. `vagrant status` in `virtualbox`, `terraform show`
in `staging`.

```
bundle exec rake status
```
