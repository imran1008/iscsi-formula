/etc/iscsi/initiatorname.iscsi:
  file:
    - managed
    - source: salt://iscsi/files/initiatorname.iscsi
    - user: root
    - group: root
    - mode: 444
    - template: jinja
    - context:
        initiator_name: {{ pillar.get('iscsi').iqn }}

/etc/iscsi/iscsid.conf:
  file:
    - managed
    - source: salt://iscsi/files/iscsid.conf
    - user: root
    - group: root
    - mode: 444
    - template: jinja
    - context:
        username: {{ pillar.get('iscsi').username }}
        password: {{ pillar.get('iscsi').password }}
        username_in: {{ pillar.get('iscsi').username_in }}
        password_in: {{ pillar.get('iscsi').password_in }}

{% for iface in pillar.get('iscsi').ifaces %}

/etc/iscsi/ifaces/{{ iface_name }}:
  file:
    - managed
    - source: salt://iscsi/files/iscsi_iface
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
        iface_name: {{ iface }}

{% endfor %}

open-iscsi-pkg:
  pkg:
    - name: open-iscsi
    - installed

open-iscsi-service:
  service.running:
    - enable: True
    - name: open-iscsi
    - require:
      - pkg: open-iscsi-pkg
    - watch:
      - file: /etc/iscsi/iscsid.conf


