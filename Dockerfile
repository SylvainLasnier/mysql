FROM        sylvainlasnier/ubuntu
MAINTAINER  Sylvain Lasnier <sylvain.lasnier@gmail.com>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.6 pwgen supervisor

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# Add MySQL scripts
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Exposed ENV
ENV MYSQL_PASS **Random**

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/var/log/mysql"]

EXPOSE 3306

# supervisor to rule them all
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord","-n"]
