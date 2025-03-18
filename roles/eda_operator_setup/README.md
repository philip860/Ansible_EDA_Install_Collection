# EDA Operator

## Overview

The EDA Operator is an Ansible-based Kubernetes Operator designed to manage the lifecycle of [EDA](https://github.com/ansible/event-driven-ansible) instances within a Kubernetes cluster. Built with the Operator SDK and Ansible, it streamlines the deployment, management, and maintenance of EDA, providing a consistent and automated approach to handling EDA installations.

## Prerequisites

Before deploying the EDA Operator, ensure you have the following:

- **Kubernetes Cluster**: A functioning Kubernetes cluster (e.g., OpenShift, Kubernetes, Minikube).
- **kubectl**: The Kubernetes command-line tool should be installed and configured to interact with your cluster.
- **Helm (optional)**: Used for managing Kubernetes applications.
- **Ansible**: Required for contributing to the EDA Operator.

## Installation

### 1. Clone the EDA Operator Repository

Begin by cloning the EDA Operator repository:

```bash
git clone https://github.com/ansible/eda-server-operator
cd eda-operator
```

### 2. Checkout the Desired Release

List available tags and checkout the desired version:

```bash
git tag
git checkout tags/<tag>
```

Replace `<tag>` with the specific version you intend to deploy, such as `2.19.1`.

### 3. Deploy the Operator Using Kustomize

With a running Kubernetes cluster, deploy the EDA Operator using Kustomize:

```bash
kubectl apply -k .
```

This command applies the necessary manifests to your cluster.

### 4. Verify Operator Deployment

Confirm that the EDA Operator is running:

```bash
kubectl get pods -n eda
```

You should see the `eda-operator-controller-manager` pod in a running state.

## Deploying an EDA Instance

### 1. Create an EDA Custom Resource

Define the EDA instance by creating a YAML file, such as `eda-demo.yml`, with the following content:

```yaml
apiVersion: eda.ansible.com/v1beta1
kind: EDA
metadata:
  name: eda-demo
spec:
  service_type: nodeport
```

### 2. Apply the Custom Resource

Apply the EDA custom resource to deploy the instance:

```bash
kubectl apply -f eda-demo.yml
```

Monitor the deployment:

```bash
kubectl get pods -l "app.kubernetes.io/managed-by=eda-operator"
```

Once the pods are running, your EDA instance is ready.

## Configuration Options

The EDA Operator offers various customization options:

- **Admin User Configuration**: Set the admin username, email, and password via Kubernetes secrets.
- **Database Configuration**: Configure external PostgreSQL databases or allow the operator to manage an internal PostgreSQL service.
- **Extra Settings**: Pass additional settings to EDA using the `extra_settings` parameter.

## Documentation

Comprehensive documentation for the EDA Operator is available at [EDA Operator Documentation](https://ansible.readthedocs.io/projects/eda-operator/).

## Contributing

Contributions are welcome. Please refer to the [contributing guidelines](https://github.com/ansible/eda-server-operator/blob/main/CONTRIBUTING.md) for more information.

## License

This project is licensed under the Apache-2.0 License.

## Author

The EDA Operator was originally built by the Ansible Team. For real-time interactions, join the community on Matrix:

- **EDA Discussions**: [#eda:ansible.com](https://matrix.to/#/#eda:ansible.com)

For more communication channels, visit the [Ansible communication guide](https://docs.ansible.com/ansible/latest/community/communication.html).

