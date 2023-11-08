# HCU Unitac – docker-compose Cluster
This is the infrastructure repository for Unitac services like DIPAS or CoSI.

We want to have a reproducible environment for our deployments and local
development machines. The less manual setup work the better.
Differences between development environments and production deployments shall be
minimal. Ideally, just by swapping certain environment variables, it should be
possible to simulate a production environment on an isolated system for debugging
or feature testing.

## Setup
The cluster is intended to be run locally as a development environment and to be
deployed onto remote machines. The differences shall be minimal.

Required software for the cluster:
- Git
- Docker
- Docker Compose

Once everything is installed on the host system, we need to pull the required
Git repositories onto the host system, which will be then mounted accordingly
into the docker-compose cluster.

List of Git repositories:
- https://github.com/citysciencelab/cosi
- https://github.com/citysciencelab/dipas-unitac
- https://github.com/citysciencelab/mpportalconfigs
- https://bitbucket.org/geowerkstatt-hamburg/masterportal

With the repositories being pulled onto the host system, we need to announce
their locations in a special `.env` file. Copy the example env file, rename it
to `.env` and write the absolute file paths to the directories of the pulled
Git repositories accordingly.

If everything was copied and inserted correctly, we can now use our make tasks
for installing and setting up the cluster.

```sh
# Build Docker images and install dependencies
make install # shorthand for make cosi_install dipas_install

# Build the CoSI project
make cosi_build

# Initialize and build the DiPaS project
make dipas_init
```

The last thing we need to setup is the nameserver. This is a step where we might
encounter major differences between the system regarding the configuration.

Firstly we want to look at the case for a local development machine.
Here we want to host and access the cluster on the same machine. This means,
that we need to announce the vhosts of the cluster in a configuration file like
`/etc/hosts` on Linux.

Example entries:

```sh
127.0.1.1       unitac.local
127.0.1.1       cosi.unitac.local
127.0.1.1       dipas.unitac.local
127.0.1.1       geoserver.unitac.local
```

All requests would be ingested by the Nginx service inside the cluster,
which in turn would redirect the request to the correct service according to
the given vhost.

On a production system, it might differ depending on the nameserver.
In general you need to provide a hostname for which you have access and
permissions to add subdomains. For the DNS records you would provide the IP
addresses (IPv4 and/or IPv6) of the host system.

If the nameserver and host system for the docker-compose cluster are on the same
physical or virtual machine, then you could also simply work with a configuration
file like `/etc/hosts` or use management tools like ProxMox or similiar.

## Usage
There are two usage scenarios, which we have to consider.

First scenario is the day-to-day development of new features in a development
environment locally.

```sh
# To start the cosi service
make cosi_start

# To start the Dipas service
make dipas_start

# Or to start/restart all at once
make start
make restart

# To stop everything
make stop

# Access the independ database management UI
make pgadmin
```

Second scenario is the deployment of this cluster onto a production machine.

```sh
# Start all services with default start commands
make deployment_start

# To stop everything
make stop
```

The development is done in the respective Git directories, which are mounted into
the cluster. No feature development in those services should change the Git
history of the infrastructure repository, unless certain reconfiguration in the
cluster is required.
