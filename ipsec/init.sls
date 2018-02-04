#ipsec

{% from "ipsec/map.jinja" import ipsec with context %}

Racoon Service:
  
  pkg.installed:
    - name: {{ ipsec.racoon_pkg }}

  service.running:
    - name: {{ ipsec.racoon_srv }}
    - enable: True
    - require:
      - pkg: {{ ipsec.racoon_pkg }}
      - file: {{ ipsec.racoon_cfg }}

  file.managed:
    - name: {{ ipsec.racoon_cfg }}
    - source: salt://ipsec/templates/racoon.conf
    - template: jinja

Raccon psk file:
  file.managed:
    - name: {{ ipsec.racoon_pskfile }}
    - source: salt://ipsec/templates/psk.txt
    - template: jinja
    - mode: 600


Setkey Service:
  service.enabled:
    - name: {{ ipsec.srv }}
    - require: 
      - pkg: {{ ipsec.racoon_pkg }}

  file.managed:
    - name: {{ ipsec.cfg }}
    - source: salt://ipsec/templates/ipsec.conf
    - template: jinja

  cmd.run:
    - name: {{ ipsec.setkeycmd }} -f {{ ipsec.cfg }}
    - onchanges:
      - file: {{ ipsec.cfg }}
 
