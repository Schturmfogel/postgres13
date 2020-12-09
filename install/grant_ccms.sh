useradd ccms
passwd ccms
groupadd ccms

chown -R ccms /var/lib/pgsql/
chgrp -R ccms /var/lib/pgsql/
chown -R ccms /usr/pgsql-13
chgrp -R ccms /usr/pgsql-13
chgrp -R ccms /var/run/postgresql/
chown -R ccms /var/run/postgresql/