First check a connection, so 
```shell
ping github.com
```

then 
```
curl -L archfi.sf.net/archfi > archfi
```
for the easy install script. I know that manually doing it is probs the "right way" to do it but tbh I don't really care because archfi is good enough to do install the arch and I don't need to spend 40min partition and mounting disks. The rest is straight foward. 

if no wifi 
enter iwctl with 
```
iwctl
```
list devices with 
```
device list
```
scan device with 
```
station wlan0 scan
```
then get networks with 
```
station wlan0 get-networks
```
connect to wifi using 
```
station wlan0 connect <name>
```
check if connected with 
```
station wlan0 show
```


For cool Pacman 
add 
`ILoveCandy` and uncomment `color` in `/etc/pacman.conf'
