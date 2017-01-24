Source (Github repository)[https://github.com/phips/ansible-bamboo]

Role Name
========

Install [Atlassian Bamboo](https://www.atlassian.com/software/bamboo)

Requirements
------------

A database, either PostgreSQL or MySQL, running somewhere.

Role Variables
--------------

All defined in defaults, so overrideable:

    bamboo:
      version:   5.5.0
      baseurl:   http://www.atlassian.com/software/bamboo/downloads/binary
      installer: atlassian-bamboo-5.5.0.tar.gz
      user:      bamboo
      # use postgresql or mysql
      dbconnector: postgresql
      packages:
        - java-1.7.0-openjdk
      tmp:       /var/tmp
      installto: /opt
      datadir:   /srv/bamboo-data


Dependencies
------------


Example Playbook
-------------------------

    - hosts: bamboo_servers
      roles:
         - { role: bamboo }

License
-------

MIT/BSD

Author Information
------------------

Mark Phillips <mark@probably.co.uk>
http://probably.co.uk
