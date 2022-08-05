# docker-compose

~~~
jenkins
mysql
spring boot application x α
~~~

# Getting Started
```shell
mysql

$ docker-compose up -d
$ docker system prune --volumes
$ mysql -u root -p
```

initdb.d 에 들어가는 dump sql 파일은 NO_AUTO_CREATE_USER 가 있으면 오류발생 - mysql8 error
