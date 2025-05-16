command:
  - /bin/bash
  - -c
  - |
    ln -sfn /home/frappe/frappe-bench/apps/helpdesk/helpdesk/public /home/frappe/frappe-bench/sites/assets/helpdesk;
    nginx-entrypoint.sh
