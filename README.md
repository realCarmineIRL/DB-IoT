# create docker mysql:
    docker run -d --name=mysql-3306 -p 3306:3306 --env="MYSQL_ROOT_PASSWORD=password" mysql:5.7 --sql-mode="NO_ENGINE_SUBSTITUTION" --group_concat_max_len=1000000 --character-set-server=utf8 --collation-server=utf8_general_ci

# stop/remove docker running images:
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q )

# connet into the db:
    you can connect using your favorite IDE or via command line.
    host: localhost
    port: 3306
    user: root
    pass: password