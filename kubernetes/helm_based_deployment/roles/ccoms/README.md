Role Name
=========

This role is for installing CCOMS application.

Requirements
------------

Database service should be started first.

Role Variables
--------------

All environemnt variable are stored in root environment folder

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }


Steps for running roles
-----------------------

``` ansible-playbook  ccoms_playbook.yaml ``` 
To run all tag inside ccoms role</br>

``` ansible-playbook -t pre_ccoms ccoms_playbook.yaml ```
To run pre-requesites inside ccoms role</br>

``` ansible-playbook -t ccoms ccoms_playbook.yaml ```
 To deploy ccoms as SAAS</br>

License
-------

BSD

Author Information
------------------

Suyog Chinche 
Contact no: 9822622279

