sed -i '15s/.*/ "type": "cluster", \n"instances": "2", \n"serviceInterfacePort": "8080\/tcp"/' ${image-file-path}

