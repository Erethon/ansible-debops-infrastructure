---

- hosts: spinny
  become: True

  roles:
    - role: debops.secret
    - role: influxdb
