sed -i '15s/.*/ "type": "cluster", \n"instances": "2", \n"serviceInterfacePort": "8080\/tcp"/' /cats/phone_automation/automation/resources/configuration-files/${system-name}/op-voice-service-docker-image.json

