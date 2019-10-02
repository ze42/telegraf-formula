{% from "telegraf/map.jinja" import data with context %}

{% if data.lookup.package_toml %}
telegraf_prereq:
  pkg.installed:
{%   if data.lookup.package_toml is list %}
  - pkgs: {{ data.lookup.package_toml|json }}
{%   else %}
  - pkgs: [{{ data.lookup.package_toml }}]
{%   endif %}
  - require_in:
    - file: telegraf_config
{% endif %}

telegraf_package:
  pkg.installed:
{% if data.lookup.package is list %}
  - pkgs: {{ data.lookup.package|json }}
{% else %}
  - pkgs: [{{ data.lookup.package }}]
{% endif %}

telegraf_config:
  file.serialize:
  - name: {{ data.lookup.config_file }}
  - formatter: toml
  - dataset: {{ data.config|json }}
  - require:
    - pkg: telegraf_package

telegraf_service:
  service.running:
  - name: {{ data.lookup.service }}
  - enable: True
  - watch:
    - file: telegraf_config
    - pkg: telegraf_package
