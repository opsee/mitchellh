# Mitchell Hashimoto Fansite

![Mitchell Hashimoto][mitchellh.jpg]

Welcome to our Mitchell Hashimoto fan site. You can join our club by following
these simple instructions.

## Organization

Terraform resources have been split up into smaller stacks so that changes can be
made more easily. This is to facilitate making changes quickly and easily while
facilitating collaboration between team members--as making a change requires that
the appropriate Terraform state be "locked" before additional changes can be made.

If you intend to change a particular stack, tell someone in #backend with @here
that you intend to change a stack. This is necessary, because after your changes
have been made, Terraform will push your copy of the state to S3. You could
unintentionally overwrite changes someone else has made. A more formal locking
mechanism can be put into place if/when we choose to move from s3 to etcd for
our state stores.

Remote state is stored in s3 in the opsee-terraform-state bucket. Each environment
for each stack has its own state file. This allows changes to be made and tested
in one environment prior to being made/tested in another environment. Each stack
has its own Makefile that can (and should) include the default Makefile in the
project's root directory.

## Making changes

Be the change you want to see in the world by editing the appropriate .tf or .tfvars
file. Then make your plan and apply it. The default Make target is `plan`.

```
λ make
terraform plan -var-file=production.tfvars -out production.plan
Refreshing Terraform state prior to plan...

aws_eip.nat: Refreshing state... (ID: eipalloc-5bb9813f)
... more refreshing state garbage ...

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed.

Your plan was also saved to the path below. Call the "apply" subcommand
with this plan file and Terraform will exactly execute this execution
plan.

Path: production.plan

~ aws_route_table.us-west-2-private
  route.1619481731.cidr_block:                "0.0.0.0/0" => ""
  route.1619481731.gateway_id:                "" => ""
  route.1619481731.instance_id:               "" => ""
  route.1619481731.nat_gateway_id:            "nat-075cf7087c6887688" => ""
  route.1619481731.network_interface_id:      "" => ""
  route.1619481731.vpc_peering_connection_id: "" => ""
  route.2642159465.cidr_block:                "" => "0.0.0.0/0"
  route.2642159465.gateway_id:                "" => "nat-075cf7087c6887688"
  route.2642159465.instance_id:               "" => ""
  route.2642159465.nat_gateway_id:            "" => ""
  route.2642159465.network_interface_id:      "" => ""
  route.2642159465.vpc_peering_connection_id: "" => ""

~ aws_vpc.default
  tags.#:    "2" => "3"
  tags.Hero: "" => "mitchellh"

Plan: 0 to add, 2 to change, 0 to destroy.
```

Once your plan has been generated, you can apply it:

```
λ make apply
terraform apply production.plan
aws_vpc.default: Modifying...
  tags.#:    "2" => "3"
  tags.Hero: "" => "mitchellh"
aws_vpc.default: Modifications complete
aws_route_table.us-west-2-private: Modifying...
  route.1619481731.cidr_block:                "0.0.0.0/0" => ""
  route.1619481731.gateway_id:                "" => ""
  route.1619481731.instance_id:               "" => ""
  route.1619481731.nat_gateway_id:            "nat-075cf7087c6887688" => ""
  route.1619481731.network_interface_id:      "" => ""
  route.1619481731.vpc_peering_connection_id: "" => ""
  route.2642159465.cidr_block:                "" => "0.0.0.0/0"
  route.2642159465.gateway_id:                "" => "nat-075cf7087c6887688"
  route.2642159465.instance_id:               "" => ""
  route.2642159465.nat_gateway_id:            "" => ""
  route.2642159465.network_interface_id:      "" => ""
  route.2642159465.vpc_peering_connection_id: "" => ""
aws_route_table.us-west-2-private: Modifications complete

Apply complete! Resources: 0 added, 2 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: .terraform/terraform.tfstate
```

Now your changes have been made and your state has been pushed to s3.