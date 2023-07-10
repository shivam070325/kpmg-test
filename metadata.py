import requests
import json

from azure.identity import ClientSecretCredential
from azure.identity._constants import AZURE_CLI_CLIENT_ID

# Specify your Azure AD tenant ID, client ID, and client secret
def get_bearer_token():
    tenant_id = '70c32259-2a9c-49c8-869c-32c6cf5fd6fc'
    client_id = '3ba36b60-43a4-46cc-9310-32a5f87c986c'
    client_secret = '9JW8Q~-kfesgIoFpySoPzSxuRpnCSaIYNGc6RdbJ'
# Specify the Azure resource URL for the VM (e.g., https://management.azure.com)
    resource_url = 'https://management.azure.com/subscriptions/51e873e7-379a-4301-a605-9b675e08dbf5/resourceGroups/Test-RG/providers/Microsoft.Compute/virtualMachines/Vm1?api-version=2023-03-01'
# Create a ClientSecretCredential instance
    credential = ClientSecretCredential(tenant_id, client_id, client_secret)
# Get the access token
    token = credential.get_token(resource=resource_url)
# Access the token value
    bearer_token = token.token
    return bearer_token

def get_azure_instance_metadata(bearer_token):
    try:
        url = 'https://management.azure.com/subscriptions/51e873e7-379a-4301-a605-9b675e08dbf5/resourceGroups/Test-RG/providers/Microsoft.Compute/virtualMachines/Vm1?api-version=2023-03-01'

        headers = {'Metadata': 'true'}
        headers = {
                    'Authorization': 'Bearer ' + bearer_token,
                    'Content-Type': 'application/json',
                    'Metadata': 'true'
                    }
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            data = response.json()

            azure_metadata = {
                'instance_id': data['compute']['vmId'],
                'region': data['compute']['location']
# Add more metadata fields as needed
            }
            return azure_metadata
        #else:
        #    raise Exception('Failed to retrieve Azure instance metadata')
    except Exception as e:
        print(e)
token=get_bearer_token()
# Call the function to retrieve Azure instance metadata
instance_metadata = get_azure_instance_metadata(token)
 
# Convert the metadata dictionary to JSON

json_output = json.dumps(instance_metadata, indent=4)

print(json_output)
