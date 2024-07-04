# !/bin/bash

# Deployment of sf metadata
sf project deploy start -d force-app

# Assigning the permission to the user
sf org assign permset --name dreamhouse
