{
  "router": {
    "password": "123456",
    "passwordVerify": "123456",
    "name": "wurstrouter"
  },
  "contact": {
    "name": "André Wurstwasser",
    "email": "doener@pumpe.net" // optional if the user does not want to register ips or vpn certs automatically
  },
  "location": {
    "lat": 52.538525899999996, // optional wenn keine ips registriert werden sollen
    "lng": 13.3853186, // same here
    "street": "Feldstraße 10", // optional
    "postalCode": "13355", // optional
    "city": "Berlin" // optional
  },
  "internet": {
    "share": true,
    "vpn": { // optional
      "crt": "",
      "key": "",
      "cacrt": "",
      "config": ""
    }
  },
  "ip": {
    "v6Prefix": "2001:bf7:c4ff:3300::/56",
    "v4MeshIps": {
      "radio0": "10.31.133.41",
      "radio1": "10.31.133.42",
      "lan": "10.31.133.43" // optional (mesh on lan)
    },
    "distribute": true, // DHCP + router advertisements / DHCPv6
    "v4DhcpPrefix": "10.31.134.32/28" // required iff distribute === true
  },
  "wifi": {
    "radio0": {
      "channel": 36,
      "ap": { // optional
        "ssid": "berlin.freifunk.net"
      }
      "mesh": { // optional
        "mode": "adhoc", // or "mesh" (802.11s), "sta", "ap"
        "ssid": "intern-ch36-bat5.freifunk.net",
        "bssid": "12:36:ca:ff:ee:ba:be", // only for mode === "adhoc"
        "meshId": "freifunk", // only for mode === "mesh"
        "batman": { // optional
          "vlan": 5
        }
      }
    },
    "radio1": {
      // see radio0
    }
  }
}
