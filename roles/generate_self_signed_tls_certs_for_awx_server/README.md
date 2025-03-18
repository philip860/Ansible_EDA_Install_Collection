# SSL Cert Configuration Role

## Overview

This Ansible role automates the setup and configuration of SSL certs for Nginx, and associated services to support EDA deployment within a Kubernetes environment. It ensures that SSL certs are set up correctly for Nginx.

## Key Functions


- **Configure SSL Certificates**: Copies self-generated SSL certificates to the appropriate Nginx directories to enable secure HTTPS communication.


## Usage

This role should be executed as part of an EDA installation process where K3s is required as the Kubernetes environment and Nginx is used as the ingress controller.

## Documentation

For more details on EDA installation and Kubernetes configuration, refer to:
- [EDA Documentation](https://ansible.readthedocs.io/projects/eda/)


## License

This project is licensed under the MIT License.

## Author

This role was created and maintained by the Ansible community.

