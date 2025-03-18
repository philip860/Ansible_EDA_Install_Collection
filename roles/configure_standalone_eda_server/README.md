# Configuration EDA Server Role

## Overview

This Ansible role automates the setup and configuration of the EDA server. It ensures that the eda-operator is deployed properly configured, and that all the necessary kubernetes configuration have been made.

## Key Functions

- **Install eda-operator**: Ensures that the eda is deployed using the eda-operator.
- **Manage Required Directories**: Creates essential directories for Helm, SSL certificates, and Nginx configuration.
- **Restart Services**: Ensures that K3s and Nginx services are restarted to apply new configurations.

## Usage

This role should be executed as part of an EDA installation process where K3s is required as the Kubernetes environment and Nginx is used as the ingress controller.

## Documentation

For more details on EDA installation and Kubernetes configuration, refer to:
- [EDA Documentation](https://ansible.readthedocs.io/projects/eda/)

## License

This project is licensed under the MIT License.

## Author

This role was created and maintained by the Ansible community.

