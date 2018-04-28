---

- hosts: docker
  become: True

  environment: '{{ inventory__environment | d({})
                   | combine(inventory__group_environment | d({}))
                   | combine(inventory__host_environment  | d({})) }}'

  roles:

    - role: debops.secret

    - role: debops.etc_services
      tags: [ 'role::etc_services' ]
      etc_services__dependent_list:
        - '{{ docker__etc_services__dependent_list }}'

    - role: debops.ferm
      tags: [ 'role::ferm' ]
      ferm__dependent_rules:
        - '{{ docker__ferm__dependent_rules }}'

    - role: debops.docker
      tags: [ 'role::docker' ]

    - role: docker
    - role: plothopes.com
