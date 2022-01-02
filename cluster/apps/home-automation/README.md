# home-automation

## Shelly

### Offline Firmware Update

1. Download the firmware you need from the [Shelly Forum Firmware Topic](https://www.shelly-support.eu/index.php?shelly-firmware-archive/).
2. Add it to repository [npawelek/firmware](https://github.com/npawelek/firmware).
3. The [nginx deployment](https://github.com/npawelek/k8s-gitops/tree/master/cluster/apps/nginx) will automatically sync the firmware repository every `60s`.
4. Use the Shelly OTA URL which points to the locally served file.
    ```
    # Set some variables to make this easier (USER and PASS are only required if authentication is enabled)
    ADDR=192.168.10.
      USER=
      PASS=

    # Shelly Flood (SHWT-1) Example
    http --auth $USER:$PASS http://$ADDR/ota?url=http://int.nathanpawelek.com/shelly/SHWT-1/v1.11.7.zip

    # Shelly Motion (SHMOS-01) Example
    http --auth $USER:$PASS http://$ADDR/ota?url=http://int.nathanpawelek.com/shelly/SHMOS-01/v2.0.5.zip
    ```
