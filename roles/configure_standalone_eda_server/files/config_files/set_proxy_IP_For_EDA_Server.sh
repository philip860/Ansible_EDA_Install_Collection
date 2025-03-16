#!/bin/bash
kubectl delete node ip-172-31-26-151.ec2.internal

systemctl restart k3s

kubectl delete pvc postgres-15-eda-postgres-15-0 -n eda

kubectl delete pv pvc-037212b4-c2b6-44b1-b1a0-fba809f9723d -n eda


#Delete eda config
kubectl delete -f  /admin_tools/eda_awx_install_config/eda-deploy/eda.yaml -n eda


# Reapply eda config
kubectl apply -f  /admin_tools/eda_awx_install_config/eda-deploy/eda.yaml -n eda



#### Functions ####
# Function to check if the required service is present
check_service_present() {
    while true; do
        local service_status
        service_status=$(kubectl get service -n eda | grep -q 'eda-ui' && echo "true" || echo "false")
        if [[ "$service_status" == "true" ]]; then
            echo "'eda-ui' found in Kubernetes services."
            return  # Exit function once service is found
        else
            echo "Waiting for 'eda-ui' to be available..."
            sleep 10  # Adjust sleep duration as needed (e.g., 10 seconds)
        fi
    done
}

# Website URL to perform GET requests (eda Server URL)
# Note: URL will be defined after 'eda-ui' is detected

# Function to wait for 'eda-ui' to be available before proceeding
wait_for_condition() {
    local trimmed_string
    trimmed_string=$(kubectl get svc eda-ui -n eda -o jsonpath='{.spec.clusterIP}')

    while true; do
        if [[ -n "$trimmed_string" ]]; then
            echo "'eda-ui' found in Kubernetes services. Proceeding with checks."

            return  # Exit function with the trimmed string value
        else
            echo "Waiting for 'eda-ui' to be available..."
            sleep 10  # Adjust sleep duration as needed (e.g., 10 seconds)
        fi
    done
}







# Function to perform GET request and check condition
perform_request() {
    local response

    echo "Checking if eda Server is available at: $URL"

    response=$(curl -s "$URL")  # Perform GET request and capture response
    # Example condition: Check if response contains a specific keyword
    if echo "$response" | grep -q 'Event Driven Automation'; then
        echo "eda Server is up!"

        # Triggering specific action (replace with actual action)

        # Replace port value in nginx file
        sed -i "s/eda-server/$trimmed_string/g" "/admin_tools/eda_awx_install_config/eda-nginx-final-ssl.conf"

        # Updating eda-ssl.conf to have the updated Port
        cat /admin_tools/eda_awx_install_config/eda-nginx-final-ssl.conf > /etc/nginx/conf.d/eda-awx-ssl.conf


        #Updating internal hostname used in nginx
        sed -i "s/ip-172-31-26-151.ec2.internal/$HOSTNAME/g" "/etc/nginx/conf.d/eda-awx-ssl.conf"


        systemctl restart nginx


        # Command to get eda admin password from Kubernetes secret
        secret_output=$(kubectl -n eda get secret eda-admin-password -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}')

        # Define the output file path
        output_file="/home/ec2-user/eda_admin_password.txt"

        # Save the output to the text file
        echo "$secret_output" > "$output_file"

        # Notify user that the output has been saved
        echo "Secret output saved to $output_file"






        exit 0  # Exit script after performing the action

    else
        echo "eda Server is not up yet..."
    fi
}

# Wait for 'eda-ui' to be available before proceeding
check_service_present



# Extract the service port eda instance is running on
get_eda_service_port_output=$(kubectl get service -n eda)
last_line=$(echo "$get_eda_service_port_output" | awk 'END {print}')
trimmed_string=$(kubectl get svc eda-ui -n eda -o jsonpath='{.spec.clusterIP}')
echo "Service Port: $trimmed_string"


URL="http://$trimmed_string"


# Infinite loop to perform the request
while true; do
    perform_request  # Perform the function call directly (no need for background execution)
    sleep 5  # Sleep for 5 seconds before the next iteration
done


