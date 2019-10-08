# PCAP Generator w/ PAYLOAD
This project is based on my pcap_generator project (https://github.com/cslev/pcap_generator), but this supports adding payloads to the packets defined in a text file.
Thus, generating packet within a given packet size is not supported (use the other project for that purpose).
If no payload is defined, packets will be generated either with random payload size (within 20-1200 bytes), or a preset static one (via command line argument).

This application still generates PCAP files from CSV files using low-level Python tools

## CSV file should look like this:
```
#this is a comment
# Some DNS response payload
timestamp=1570500810.431494,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=10.0.0.1, dst_ip=10.0.0.2, src_port=53,dst_port=45212,payload=dns_example.payload
timestamp=1570500810.431594,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=10.0.0.1, dst_ip=10.0.0.2, src_port=53,dst_port=44212,payload=dns_example.payload
timestamp=1570500810.431694,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=10.0.0.1, dst_ip=10.0.0.2, src_port=53,dst_port=43212,payload=dns_example.payload
timestamp=1570500810.431794,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=8.8.8.8, dst_ip=10.0.0.2, src_port=53,dst_port=42212,payload=dns_example.payload
timestamp=1570500810.431894,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=8.8.4.4, dst_ip=10.0.0.2, src_port=53,dst_port=41212,payload=dns_example.payload
timestamp=1570500810.431994,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=123.123.23.1, dst_ip=10.0.0.2, src_port=53,dst_port=44422,payload=dns_example.payload
timestamp=1570500810.432094,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=12.23.42.222, dst_ip=10.0.0.2, src_port=53,dst_port=44122,payload=dns_example.payload
timestamp=1570500810.432194,src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=10.0.0.1, dst_ip=10.0.0.2, dst_port=8192,vlan=10
# end of DNS response payload
src_mac=20:00:00:00:00:01,dst_mac=20:00:00:00:00:02, vlan=1000
src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=10.0.0.1, dst_ip=10.0.0.2, dst_port=22
ext_src_ip=192.168.1.20, ext_dst_ip=192.168.1.1, gtp=255, src_ip=10.0.0.1, dst_ip=10.0.0.2, src_port=2048, dst_port=4096
```

If a necessary timestamp/L2/L3/L4/GTP/payload (header) field is missing  default values will be used, which can be changed by input arguments.
 
## Requirements
 - Python
 
## Quick walkthrough
###### First, download the source
```
$ git clone https://github.com/cslev/pcap_generator_with_payload
$ cd pcap_generator_with_payload
```

###### Create your own CSV file, then execute the following command:
```
$ python pcap_generator_from_csv.py -i YOUR_INPUT.CSV -o YOUR_DESIRED_PCAPFILENAME
```
`.pcap` will be appended to your output name

###### For additional arguments, see help
```
$ python pcap_generator_from_csv.py -h

usage: pcap_generator_from_csv.py [-h] -i INPUT -o OUTPUT [-p PACKETSIZES]
                                  [-a SRC_MAC] [-b DST_MAC] [-c VLAN]
                                  [-d SRC_IP] [-e DST_IP] [-f SRC_PORT]
                                  [-g DST_PORT] [-j GTP_TEID] [-t TIMESTAMP]
                                  [-v]


Usage of PCAP generator from CSV file

optional arguments:
  -h, --help            show this help message and exit
  -i INPUT, --input INPUT
                        Specify the name of the input CSV file. For syntax,
                        see input.csv.example!
  -o OUTPUT, --output OUTPUT
                        Specify the output PCAP file's basename! Output will
                        be [output].pcap extension is not needed!
  -p PAYLOADSIZE, --payloadsize PAYLOADSIZE
                        Specify here the default payloadsize if payload is not
                        defined in your input.csv! Default is a random, which
                        is between 20--1200 to surely avoid too big MTU)
  -a SRC_MAC, --src_mac SRC_MAC
                        Specify default source MAC address if it is not
                        present in the input.csv. Default: 00:00:00:00:00:01
  -b DST_MAC, --dst_mac DST_MAC
                        Specify default destination MAC address if it is not
                        present in the input.csv. Default: 00:00:00:00:00:02
  -c VLAN, --vlan VLAN  Specify default VLAN tag if it is not present in the
                        input.csv. Default: No VLAN
  -d SRC_IP, --src_ip SRC_IP
                        Specify default source IP address if it is not present
                        in the input.csv. Default: 10.0.0.1
  -e DST_IP, --dst_ip DST_IP
                        Specify default destination IP address if it is not
                        present in the input.csv. Default: 10.0.0.2
  -f SRC_PORT, --src_port SRC_PORT
                        Specify default source port if it is not present in
                        the input.csv. Default: 1234
  -g DST_PORT, --dst_port DST_PORT
                        Specify default destination port if it is not present
                        in the input.csv. Default: 80
  -j GTP_TEID, --gtp_teid GTP_TEID
                        Specify default GTP_TEID if it is not present in the
                        input.csv. Default: NO GTP TEID
  -t TIMESTAMP, --timestamp TIMESTAMP
                        Specify the default timestamp for each packet if it is
                        not present in the input.csv. Default: Use current
                        time
  -v, --verbose         Enabling verbose mode
```

## Example
Check the provided `input.csv` (and `dns_example.payload`) for more details. 

### How to get some payload?
Dump your traffic via *tcpdump* or *wireshark*. Open the dumped `dump.pcap` file with Wireshark and click on the useful payload you want to export in the middle pane (e.g., Domain Name System (response)). 

Then, the corresponding HEX strings will be highlighted in the bottom pane.

Now, click again on the usefule payload but with your right mouse button and click on `Show packet bytes`.

You can see the payload now, however it is in ASCII. In the bottom (above the `Find:` textfield), change `Show as` to RAW (not HEX DUMP!).
Copy-paste the raw HEX string into a textfile, save it (`example.payload`), and point to that payload file in your `input.csv` via `payload=example.payload` for the packets you want to have that specific payload.
