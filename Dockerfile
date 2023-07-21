# start from a base ubuntu image
FROM ubuntu:22.04

# set users cfg file
ARG USERS_CFG=users.json

# Install pre-reqs
RUN apt-get update
RUN apt-get install -y curl vim sudo wget rsync
RUN export DEBIAN_FRONTEND=noninteractive; apt-get install -y apache2
RUN apt-get install -y python2
RUN apt-get install -y supervisor
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN ln -s /usr/bin/python2 /usr/bin/python & \
  ln -s /usr/bin/pip2 /usr/bin/pip
# Fetch  brat
RUN mkdir /var/www/brat
RUN cd /var/www/brat \
  && wget https://github.com/nlplab/brat/archive/refs/tags/v1.3p1.tar.gz \
  && tar -xf v1.3p1.tar.gz --strip-components=1 \
  && rm v1.3p1.tar.gz


COPY brat_install_wrapper.sh /usr/bin/brat_install_wrapper.sh
RUN chmod +x /usr/bin/brat_install_wrapper.sh

# Make sure apache can access it
RUN chown -R www-data:www-data /var/www/brat/

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# add the user patching script
COPY user_patch.py /var/www/brat/user_patch.py

# Enable cgi
RUN a2enmod cgi

EXPOSE 80

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

CMD ["/usr/bin/supervisord"]





