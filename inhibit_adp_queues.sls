# salt/mwmodern/inhibit_adp_queues.sls

{% import_yaml "mwmodern/mw_os_patching_vars.yml" as mw_data %}

{% for fs in mw_data.adp.mountpoints %}

{{fs}}_mounted:
  module.run:
    - name: mount.is_mounted
    - m_name: {{fs}}
{% endfor %}

inhibit_adp_queues:
  cmd.run:
    - name: runmqsc {{ salt['pillar.get'](grains['host']) }} < AdapterInhibit.mqsc
    - cwd: /home/mqm/scripts
    - runas: {{ mw_data.adp.users.q_enable_inhibit }}
    - require:
      - /home_mounted
