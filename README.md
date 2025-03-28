# EDA Standalone Server Installation

## Overview
This Ansible playbook automates the installation and configuration of an EDA standalone server. EDA is an open-source web-based automation platform that provides a user-friendly interface for Ansible.

This is not a development EDA-server but a fully functionality install of a Ansible EDA Server.

## Prerequisites

- A Linux-based server (Ubuntu, CentOS, RHEL)
- Ansible installed on your local system
- SSH access to the target server
- Sufficient resources (minimum: 4 CPU cores, 8GB RAM, 80GB disk space - please make sure to have sufficent storage, or install may fail)
- Internet access for package installations

## Playbook Details

### Playbook Name

**configure_eda_standalone.yml**

### Variables (Prompted or Predefined)

This playbook includes optional interactive prompts for user inputs. Uncomment the `vars_prompt` section in the playbook to enable them, or define the variables manually.

#### Required Variables:
- `eda_single_node`: Target server for EDA installation
- `eda_user_password_var`: Password for the local EDA user
- `ansible_aap_controller`:  Hostname of the Ansible AAP/AWX Controller Server



### Roles Used in the Playbook

The playbook uses the following roles:

1. **install_required_packages** - Installs dependencies required for EDA.
2. **install_k3s** - Sets up a lightweight Kubernetes distribution (K3s) for EDA.
3. **generate_self_signed_tls_certs_for_eda_server** - Creates self-signed TLS certificates for secure communication.
4. **eda_operator_setup** - Deploys the EDA Operator to manage EDA in Kubernetes.
5. **configure_standalone_eda_server** - Configures and finalizes the standalone EDA server setup.
6. **configure_eda_server_proxy** - Configures Nginx reverse proxy server.
7. **wait_for_pods_to_initialize** - Wait for pods to fully initialize.



## Operating Systems Install Tested On

The following operating systems were tested with this EDA standalone server installation:

Alternatively,
  - Version: `8/9`

- **Centos**: Community ENTerprise Operating System.
  - Version: `8/9`

- **Ubuntu**: Canonical Ubuntu.
  - Version: `22.04.5 LTS`



## Essential Software Components

The following software components are used to complete the EDA standalone server installation:

- **EDA Operator**: Automates the deployment and management of EDA in Kubernetes.
  - Version: `main`
- **K3s**: A lightweight Kubernetes distribution used to run EDA.
  - Version: `v1.31.6+k3s1`
- **Helm**: A package manager for Kubernetes, used to manage EDA deployment.
  - Version: `v3.15.3`
- **PostgreSQL**: The database backend for EDA.
  - Version: `15`

## Keynote: K3s and Ingress Configuration

By default, K3s installs the Traefik Ingress Controller, which uses strict DNS resolution. While this may be suitable for some environments, it can cause issues with EDA resolving to the backend correctly, unless you use the EXACT hostname use specified at the star of the install. To ensure broader compatibility and improved functionality across various use cases, we have removed the Traefik Ingress Controller and instead set up an NGINX proxy directly on the server. This provides greater flexibility in managing ingress traffic and enhances overall system performance.

## Installation Steps

### 1. Clone the Repository (Option 1)

```sh
git clone https://github.com/philip860/Ansible_EDA_Install_Collection
cd ansible-eda-install
```

### 1. Install via Ansible Galaxy (Option 2)

Alternatively, you can install the collection from Ansible Galaxy:

```sh
ansible-galaxy collection install philip860.eda_install
```

### 2. Update Inventory and Variables

Modify the `inventory.yml` file to include your target server details.

Alternatively, you can define variables in `vars/main.yml` instead of using prompts.

### 4. Generate a Secure Password

When the playbook runs you will be prompted to specify passwords for the following:

- `eda_user_password_var`: Password for EDA PostgreSQL database


You can generate random passwords using this command below:

```sh
date +%s | sha256sum | base64 | head -c 32 ; echo
```

### 5. Run the Playbook

For repository installation, execute the playbook using:

```sh
ansible-playbook configure_eda_standalone.yml -vvv
```

If using the Ansible Galaxy collection, execute the playbook using:

```sh
ansible-playbook "$HOME/.ansible/collections/ansible_collections/philip860/eda_install/Configure_AWX_Event_Driven_Ansible.yml" -vvv
```

If using prompts, remove `vars_prompt` comments before running.

### 6. Verify the Installation

Once the playbook completes, verify the EDA setup:

- Access EDA via the web UI: `https://<server-ip>`
- Log in with the admin credentials specified earlier. (Ansible playbook will show users the admin password at the end.)

## Troubleshooting

- Ensure the target server meets resource requirements.
- Check logs for errors:
  ```sh
  journalctl -u k3s -f
  kubectl logs -n eda eda-operator-xxxx
  ```
- Validate Kubernetes pods:
  ```sh
  kubectl get pods -n eda
  ```



## SSL Cert Update

- A default SSL cert (tls.crt) & key (tls.key), is created to enable HTTPS for the EDA server.
- The default cert is located here:
```sh
  ls /etc/nginx/certs/
```
- To add your own custom SSL certs you will need to replace the default (tls.crt) & key (tls.key)
```sh
  openssl req -x509 -newkey rsa:2048 -keyout req.key -out req.crt -nodes -days 365 -subj "/C=US/ST=North Carolina/L=Raleigh/O=RedHat/CN=quart.apps.ocp4.example.com"
  cp -r /full_path/req.crt /etc/nginx/certs/server.crt
  cp -r /full_path/req.key /etc/nginx/certs/server.key
  systemctl restart nginx
```


## Installation Workflow

### 1. Start of Installation and Variable Prompts
![Initial variable prompts](https://raw.githubusercontent.com/philip860/Ansible_EDA_Install_Collection/main/screenshots/EDA-Server-Install.PNG)

Image shows: user prompts for the required information needed at the beginning of the installation process.

### 2. Pods Starting to Initialize
![Pods starting to initialize](https://raw.githubusercontent.com/philip860/Ansible_EDA_Install_Collection/main/screenshots/EDA-Server-Pods-Starting.PNG)

Image shows: what a user might see if they ran a 'kubectl get pods -n eda' while the ansible-playbook is running the installation.

### 3. EDA Install Completed Progress
![Install completed](https://raw.githubusercontent.com/philip860/Ansible_EDA_Install_Collection/main/screenshots/EDA-Server-Install-Finished.PNG)

Image shows: what a user will see if they tried to access EDA-Server with a web browser before the pods finished initializing.


### 4. Pods Finshed Initializing - Login Ready!
![Default login screen](https://raw.githubusercontent.com/philip860/Ansible_EDA_Install_Collection/main/screenshots/EDA-Default-Login-Screen.PNG)

Image shows: Default EDA login screen accessible after the pods finised initializing.

### 5. Successfully logged in - EDA GUI
![EDA GUI](https://raw.githubusercontent.com/philip860/Ansible_EDA_Install_Collection/main/screenshots/EDA-GUI.PNG)

Image shows: User logged into EDA server, via the admin user.


## Final Notes
Depending on your system's resources this installation can take anywhere from about 25mins to 45min to fully complete.

If any issues occur during the build, first check to make sure your system has enough free storage available.

The following commands can help to shed some light on possible installation issues with EDA & Kubernetes Use the command "kubectl get pods -n eda" to get the full names of the pods because they are subject to change.

- Show all eda related pods running for kubernetes:
```sh
  kubectl get pods -n eda
```
- Show all related events for eda deployment in kubernetes:

```sh
  kubectl get events -n eda
```

- Show all related information for the eda-operator-controller-manager pod:

```sh
  kubectl logs eda-operator-controller-manager-subject_to_change -f -n eda
```


## Closing
The EDA server requires a Ansible AAP/AWX Controller node to be already setup in advance in order to work properly.

In your AAP/AWX Server, you need to generate a Oauth token and then use that in the EDA server, which will connect back to the AAP/AWX server to run the playbooks there. 

## License
This project is licensed under the MIT License.

## Addional questions/inquiries
Email: philipduncan860@gmail.com

## Author
[Philip Duncan](https://github.com/philip860/)

