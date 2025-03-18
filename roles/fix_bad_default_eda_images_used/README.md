# Temporary Fix for bad default Images Role

## Overview

This Ansible role pulls down older tested EDA images from quay.io/philip860  to make sure they are fully initialized. 

## Key Functions


- **Work around for issue with version: main & version: 1.0.2**: Pulls down and replaces k3s default EDA images with ones from quay.io/philip860.


## Usage

This role should ONLY be used if you experience an issue using the default images in your environment.

## Documentation

For more details on EDA installation and Kubernetes configuration, refer to:
- [Kuberentes Documentation](https://kubernetes.io/docs/home/)


## License

This project is licensed under the MIT License.

## Author

This role was created and maintained by the Ansible community.

