# docker_init

## docker-compose
~~~
mysql
spring boot application x α
~~~

# Getting Started

`docker-compose.yaml` 파일이 있는 디렉토리로 이동한 후에 다음 명령어를 실행하면 됩니다.

```
docker-compose up
```

이 명령어는 `docker-compose.yaml` 파일을 기반으로 하여 Docker 컨테이너를 실행합니다. 만약 백그라운드에서 실행하고 싶다면 `-d` 옵션을 추가하면 됩니다.

```
docker-compose up -d
``` 

컨테이너를 종료하려면 다음 명령어를 실행합니다.

```
docker-compose down
``` 

컨테이너를 다시 빌드하려면 `--build` 옵션을 추가하면 됩니다.

```
docker-compose up --build
```
---
`docker-entrypoint-initdb.d` 디렉토리에 위치한 스크립트 파일들이 실행되며 초기 데이터를 삽입합니다. 이를 통해 컨테이너가 시작될 때 초기 데이터를 삽입할 수 있습니다.

```
2023-04-29 22:53:06 mysql8  | 2023-04-29T13:53:06.075735Z 0 [ERROR] [MY-010457] [Server] --initialize specified but the data directory has files in it. Aborting.
2023-04-29 22:53:06 mysql8  | 2023-04-29T13:53:06.075941Z 0 [ERROR] [MY-013236] [Server] The designated data directory /var/lib/mysql/ is unusable. You can remove all files that the server added to it.
2023-04-29 22:53:06 mysql8  | 2023-04-29T13:53:06.078470Z 0 [ERROR] [MY-010119] [Server] Aborting
```

해당 오류는 MySQL이 --initialize 옵션을 사용하여 데이터베이스 파일을 초기화하려고 했지만, 데이터 디렉토리에 이미 파일이 존재해서 오류가 발생한 것입니다. 따라서 해당 오류를 해결하려면, 데이터 디렉토리를 삭제하거나 이전 데이터를 백업해두고 초기화를 다시 실행해야 합니다.

---

Docker 컨테이너에 들어가는 방법은 `docker exec` 명령어를 사용하는 것입니다.

1. 우선 실행 중인 Docker 컨테이너의 ID를 확인합니다.

```
docker ps
```

2. 해당 컨테이너의 쉘에 들어갑니다.

```
docker exec -it <컨테이너 ID> sh
```

위 명령어에서 `-it` 옵션은 컨테이너 안에서 대화형 쉘을 실행하고 터미널에 출력 결과를 표시하도록 설정합니다. `sh`는 쉘의 종류를 지정합니다. 이 경우, 컨테이너 내부에서 Bash 쉘을 실행할 수 있습니다.

또는, 아래와 같이 컨테이너의 이름으로 접근할 수도 있습니다.

```
docker exec -it <컨테이너 이름> sh
```

이렇게 하면 컨테이너 내부로 들어가서 명령어를 실행하거나 파일을 수정할 수 있습니다.

---

`mysql -u root -p` 명령어는 MySQL 데이터베이스에 root 계정으로 로그인하는 명령어입니다. `-u` 옵션으로 로그인할 계정을 지정하고 `-p` 옵션을 사용하면 비밀번호를 입력할 수 있습니다.

실행하면 비밀번호를 입력하는 프롬프트가 나타납니다. MySQL의 root 계정 비밀번호를 입력하면 로그인할 수 있습니다.

```
mysql -u root -p
```
```sql
SELECT User, Host FROM mysql.user;
```
+------------------+-----------+
| User             | Host      |
+------------------+-----------+
| compig           | %         |
| root             | %         |
| mysql.infoschema | localhost |
| mysql.session    | localhost |
| mysql.sys        | localhost |
| root             | localhost |
+------------------+-----------+
```sql
show grants;
```
+-------------------------------------------------------+
| Grants for compig@%                                   |
+-------------------------------------------------------+
| GRANT USAGE ON *.* TO `compig`@`%`                    |
| GRANT ALL PRIVILEGES ON `database1`.* TO `compig`@`%` |
| GRANT ALL PRIVILEGES ON `database2`.* TO `compig`@`%` |
+-------------------------------------------------------+

```sql
create user 'compig'@'localhost' IDENTIFIED BY 'compig!';
GRANT CREATE ON *.* TO 'compig'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

MySQL에서 계정 삭제를 수행하는 방법은 다음과 같습니다.

1. MySQL에 root 계정으로 접속합니다.
2. 다음 명령어를 입력하여 삭제하려는 계정을 확인합니다.

   ```
   SELECT User, Host FROM mysql.user;
   ```

3. 삭제하려는 계정의 권한을 모두 제거합니다.

   ```
   REVOKE ALL PRIVILEGES, GRANT OPTION FROM '계정명'@'호스트명';
   ```

4. 계정을 삭제합니다.

   ```
   DROP USER '계정명'@'호스트명';
   ```

위의 과정을 순서대로 진행하면 해당 계정을 삭제할 수 있습니다. 단, 계정 삭제를 수행하기 전에 해당 계정이 사용 중인 데이터베이스와 테이블을 확인하여 데이터 손실이 없도록 백업해 두는 것이 좋습니다.