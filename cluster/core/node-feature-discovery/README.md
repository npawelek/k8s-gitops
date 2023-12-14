# Gathering pciId values

```shell
lspci -vmnn
# ... snippet ...
Device: 00:02.0
Class:  VGA compatible controller [0300]
Vendor: Intel Corporation [8086]
Device: Iris Graphics 540 [1926]
SVendor:        Intel Corporation [8086]
SDevice:        Iris Graphics 540 [2063]
Rev:    0a
# ... snippet ...
```

```shell
lspci -nn |grep  -Ei 'VGA|DISPLAY'
00:02.0 VGA compatible controller [0300]: Intel Corporation TigerLake-LP GT2 [Iris Xe Graphics] [8086:9a49] (rev 01)
31:00.0 VGA compatible controller [0300]: Intel Corporation Device [8086:56a2] (rev 08)
```
