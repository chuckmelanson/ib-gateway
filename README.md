Interactive Brokers Gateway Running Over Docker
---------

Uses version 3.8.7 of IBC and 985 of the IB Gateway. Note that this version of IBC does not support supression of the new "Bid, Ask and Last Size Display Update" warning dialog box.

> Author: Chuck Melanson (chuckmelanson@gmail.com)
> References:
> - [kaminsod/ib-gateway-docker](https://github.com/kaminsod/ib-gateway-docker)
> - [mvberg/ib-gateway-docker](https://github.com/mvberg/ib-gateway--docker)

License
-------
IBC is licensed under the
[GNU General Public License](http://www.gnu.org/licenses/gpl.html) version 3.


## Build

```
sh docker build . -t ib-gateway
```
or
```
chmod +x build_docker_image.sh && ./build_docker_image.sh 
```

## Running

```
sh docker run -p 4003:4003 -p 5903:5903 \
    --env TWSUSERID=YOUR_USER_ID \
    --env TWSPASSWORD=YOUR_PASSWORD \
    ib-gateway:latest
```
or use included docker-compose.yml
```
version: '3.8'

services:
    tws_ibc_paper:
        container_name: ibc_gateway
        image: 'chuckmelanson/ib-gateway:latest'
        restart: 'always'
        network_mode: bridge
        ports:
            - '4003:4003'
            - '5903:5903'
```

