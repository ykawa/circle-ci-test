FROM circleci/php:5.6-cli-stretch
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# COPY php.ini /usr/local/etc/php/
RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends gnupg ca-certificates curl git zip apt-utils dialog zlib1g-dev mariadb-client sudo \
  && sudo docker-php-ext-install zip pdo_mysql \
  && sudo groupadd --gid $USER_GID $USERNAME \
  && sudo useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL | sudo tee /etc/sudoers.d/$USERNAME \
  && sudo chmod 0440 /etc/sudoers.d/$USERNAME \
  && sudo apt-get autoremove -y \
  && sudo apt-get clean -y

# #Composer install
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#   && php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
#   && php composer-setup.php \
#   && php -r "unlink('composer-setup.php');" \
#   && mv composer.phar /usr/local/bin/composer
# 
# ENV COMPOSER_ALLOW_SUPERUSER 1
# ENV COMPOSER_HOME /composer
# RUN /usr/local/bin/composer global require "laravel/installer"

# USER $USERNAME
# ENV PATH $PATH:/var/www/vendor/bin:/composer/vendor/bin
# ENV HOME /home/$USERNAME
# ENV COMPOSER_HOME $HOME
# WORKDIR /var/www

# ENV LANG C.UTF-8
# WORKDIR /home/$USERNAME

