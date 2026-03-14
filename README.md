# ProgressSoft Assignment — Complete Documentation

**Student:** Dania Bdour  
**Date:** March 2026  
**GitHub:** https://github.com/DaniaBdour/progresssoft-assignment  
**Docker Hub:** https://hub.docker.com/r/daniaalbdour1/my-tomcat-app  

---

## Repository Structure

```
progresssoft-assignment/
├── Section1_Linux/
│   └── sysinfo.sh
├── Section2_SQL/
│   ├── tables.sql
│   ├── q2.sql
│   ├── q3.sql
│   ├── q4.sql
│   ├── q5.sql
│   └── q6.sql
├── Section3_Tomcat/
│   ├── Vagrantfile
│   └── provision.sh
├── Section4_DevOps/
│   ├── Dockerfile
│   └── nginx-deployment.yaml
├── screenshots/
│   └── (all screenshots here)
└── README.md
```

---

## Section 1 — Linux

### OS: Ubuntu 24.04 LTS (installed directly on machine)

### Task 1 — System Information Script

**File:** `Section1_Linux/sysinfo.sh`

The script collects and displays:
- Executed by, Hostname, Local IP, Public IP
- OS type, Kernel version, Architecture, Virtualisation
- Server time, Timezone, Uptime
- Total RAM, Used RAM, Swap, CPU Cores
- Disk usage, Network interface, Default gateway

**How to run:**
```bash
chmod +x sysinfo.sh
./sysinfo.sh
```

### Task 2 — Create User PS

```bash
sudo groupadd PSgroup
sudo groupadd dba
sudo useradd -g PSgroup -G dba -m -s /bin/bash PS
sudo passwd PS
id PS
```

- Primary group: PSgroup  
- Secondary group: dba  
- Home directory: /home/PS  
- Shell: /bin/bash  

### Task 3 — Root Password

```bash
sudo passwd root
```

### Task 4 — Install MySQL and HAProxy

```bash
sudo apt update
sudo apt install -y mysql-server haproxy
sudo systemctl start mysql && sudo systemctl enable mysql
sudo systemctl start haproxy && sudo systemctl enable haproxy
```

### Task 5 — Firewall — Allow Port 3306

```bash
sudo ufw enable
sudo ufw allow 3306/tcp
sudo ufw allow 3306/udp
sudo ufw status verbose
```

### Task 6 — File Transfer Options

| Method | Command |
|--------|---------|
| SCP | `scp file.txt user@IP:/path/` |
| SFTP | `sftp user@IP` then `put file.txt` |
| rsync | `rsync -avz file.txt user@IP:/path/` |
| Vagrant | Files in Vagrantfile folder appear at `/vagrant/` |

### Task 7 — Linux Theory

**Architecture:**
- Hardware → Kernel → Shell → User Space
- Kernel manages CPU, RAM, devices, filesystem
- Shell interprets commands and talks to kernel
- User space is where all applications run

**Key Directories:**

| Directory | Purpose |
|-----------|---------|
| / | Root of entire filesystem |
| /etc | System configuration files |
| /home | User home directories |
| /var | Variable data, logs |
| /opt | Optional/third-party software |
| /tmp | Temporary files (cleared on reboot) |
| /proc | Live kernel and process info |
| /dev | Device files |

**Distributions:**
- Ubuntu — most popular, APT package manager, 5-year LTS support
- CentOS/AlmaLinux — enterprise standard, DNF package manager
- Debian — extremely stable, base for Ubuntu
- Fedora — cutting-edge, Red Hat sponsored
- Arch Linux — minimal, rolling release, advanced users

---

## Section 2 — SQL (Oracle via Docker)

### Oracle Setup

Oracle XE 21c was run via Docker:

```bash
docker run -d \
  --name oracle-xe \
  -e ORACLE_PASSWORD=Oracle123 \
  -p 1521:1521 \
  -v oracle-data:/opt/oracle/oradata \
  gvenzl/oracle-xe:21-slim
```

### Theory

**DML, DDL, DCL, TCL:**

| Type | Commands | Description |
|------|----------|-------------|
| DDL | CREATE, ALTER, DROP, TRUNCATE | Defines database structure |
| DML | SELECT, INSERT, UPDATE, DELETE | Manipulates data |
| DCL | GRANT, REVOKE | Controls access |
| TCL | COMMIT, ROLLBACK, SAVEPOINT | Manages transactions |

**JOIN Types:**

| JOIN | Description |
|------|-------------|
| INNER JOIN | Only matching rows from both tables |
| LEFT JOIN | All rows from left + matching from right |
| RIGHT JOIN | All rows from right + matching from left |
| FULL OUTER JOIN | All rows from both tables |
| CROSS JOIN | Every row paired with every other row |
| SELF JOIN | Table joined to itself (used for manager lookup) |

**RDBMS vs NoSQL:**
- RDBMS: structured tables, fixed schema, ACID compliant. Examples: Oracle, PostgreSQL, MySQL
- NoSQL: flexible schema, horizontal scaling. Types: Document (MongoDB), Key-Value (Redis), Column (Cassandra), Graph (Neo4j)

**Aggregation Functions:** COUNT, SUM, AVG, MIN, MAX — used with GROUP BY and HAVING

**Date Functions (Oracle):** SYSDATE, TO_DATE, TO_CHAR, ADD_MONTHS, MONTHS_BETWEEN, EXTRACT

**String Functions (Oracle):** UPPER, LOWER, SUBSTR, INSTR, TRIM, REPLACE, CONCAT, NVL

**Constraints:** PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT

**Indexes:** Speed up SELECT queries. Created automatically for PRIMARY KEY and UNIQUE constraints.

### Q1 — Tables Created

- Gender (Gender_ID, Name)
- University (ID, Name)
- MyDepartment (Dept_ID, Name)
- MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID, MANAGER_ID, JOB_TITLE, EMP_IMAGE)

**File:** `Section2_SQL/tables.sql`

### Q2 — Employee Details Query

5-table LEFT JOIN including a SELF JOIN on MyEmployee to get the Manager name.

**File:** `Section2_SQL/q2.sql`

### Q3 — Salary by Job Title

Uses WHERE to exclude Sales, GROUP BY to group by job title, HAVING to filter totals > 2500.

**File:** `Section2_SQL/q3.sql`

### Q4 — Four Errors Fixed

**Original broken query:**
```sql
SELECT empno, ename,
salary x 12 ANNUAL SALARY; FROM emp;
```

**Four errors:**
1. `x` → `*` (wrong multiplication operator)
2. `ANNUAL SALARY` → `"ANNUAL SALARY"` (space in alias needs double quotes)
3. Semicolon `;` before FROM ends the statement early → remove it
4. Missing comma after `ename`

**Fixed query:**
```sql
SELECT empno,
       ename,
       salary * 12 AS "ANNUAL SALARY"
FROM emp;
```

**File:** `Section2_SQL/q4.sql`

### Q5 — Function F_HR_QUERY

Oracle PL/SQL function that returns a SYS_REFCURSOR of all employees hired after SCOTT (09/09/1987).

Expected output: Khaled (1990), Lina (1992), Sara (1995)

**File:** `Section2_SQL/q5.sql`

### Q6 — Procedure P_COPY_EMPLOYEE

Oracle PL/SQL procedure that drops MyEmployee_update if it exists, then recreates it as a full copy of MyEmployee using EXECUTE IMMEDIATE (required for DDL inside PL/SQL).

**File:** `Section2_SQL/q6.sql`

---

## Section 3 — Apache Tomcat 9

### Theory

**JVM (Java Virtual Machine):**
The JVM is the runtime engine that executes Java programs. Java source code is compiled into bytecode, which the JVM translates into native machine instructions at runtime. This enables Java's write-once-run-anywhere design — the same compiled code runs on any OS with a JVM installed. The JVM also manages garbage collection, JIT compilation, thread management, and security.

**Application Server:**
An application server is a platform that provides a managed runtime environment for server-side applications. It sits between the web browser and the database, providing HTTP handling, session management, connection pooling, security, and logging. Apache Tomcat is a Servlet Container implementing Java Servlet 4.0 and JSP 2.3 specifications.

**WAR File:**
A WAR (Web Application Archive) is a ZIP-format package containing all components of a Java web application: compiled classes, JSPs, HTML/CSS/JS, WEB-INF/web.xml, and library JARs. When copied to Tomcat's webapps/ directory, Tomcat auto-deploys it. A WAR named ROOT.war is served at the root URL (http://host/).

### Practice 1 — Install Tomcat + Nginx Reverse Proxy

- Tomcat 9.0.115 installed at /opt/tomcat9
- Port changed from 8080 to 7070
- Nginx configured as reverse proxy on port 80
- DNS name: myapp.local → resolves to localhost

```bash
curl http://myapp.local   # goes through Nginx → Tomcat on 7070
curl http://localhost:7070  # direct Tomcat access
```

### Practice 2 — Change Port to 7070

```bash
sudo sed -i 's/port="8080"/port="7070"/' /opt/tomcat9/conf/server.xml
```

### Practice 3 — Vagrantfile

**Files:** `Section3_Tomcat/Vagrantfile` and `Section3_Tomcat/provision.sh`

- Input: bento/ubuntu-24.04
- Forwards guest port 7070 to host port 9090
- VM memory: 2048 MB
- Installs Java 8 and Apache Tomcat 9.0.115
- Configures Nginx reverse proxy

---

## Section 4 — DevOps

### Docker Theory

**What is Docker?**
Docker is a platform for building and running containerized applications. A container packages an application and all its dependencies into one portable unit that runs identically on any machine.

| Term | Definition |
|------|-----------|
| Image | Read-only blueprint built from a Dockerfile |
| Container | Running instance of an image |
| Dockerfile | Script with build instructions |
| Docker Hub | Public registry for sharing images |
| Volume | Persistent storage for containers |

**Basic Docker Commands:**
```bash
docker build -t name:tag .     # build image
docker run -d -p host:cont img  # run container
docker ps                       # list running containers
docker logs CONTAINER           # view output
docker exec -it CONTAINER bash  # open shell inside
docker stop/rm CONTAINER        # stop and delete
docker push user/image:tag      # push to Docker Hub
```

### Task 1 — Dockerfile + Docker Registry

**File:** `Section4_DevOps/Dockerfile`

```dockerfile
FROM tomcat:9.0-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY sample.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

**Docker Hub Image:** https://hub.docker.com/r/daniaalbdour1/my-tomcat-app

**Pull and run:**
```bash
docker pull daniaalbdour1/my-tomcat-app:1.0
docker run -d -p 8888:8080 --name myapp daniaalbdour1/my-tomcat-app:1.0
curl http://localhost:8888
```

### Task 2 — Nginx and PostgreSQL Containers

```bash
# Nginx
docker run -d --name nginx-server -p 8090:80 nginx:latest

# PostgreSQL
docker run -d \
  --name postgres-db \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=secret123 \
  -e POSTGRES_DB=mydb \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:15
```

### Kubernetes Theory

**What is Kubernetes?**
Kubernetes (K8s) is an open-source container orchestration platform that automates deployment, scaling, load balancing, self-healing, and management of containerized applications across a cluster of machines.

**Master vs Worker Node:**

| Node | Role | Runs |
|------|------|------|
| Master (control-plane) | Controls the cluster | API Server, Scheduler, Controller Manager, etcd |
| Worker | Runs application pods | kubelet, kube-proxy, container runtime |

**How to identify:**
```bash
kubectl get nodes
# control-plane = master
# <none>        = worker
```

### Task 3 — K3s Deployment

**File:** `Section4_DevOps/nginx-deployment.yaml`

```bash
# Install K3s
curl -sfL https://get.k3s.io | sh -

# Deploy
kubectl create deployment nginx-deploy --image=nginx:latest
kubectl expose deployment nginx-deploy --port=80 --type=NodePort
kubectl scale deployment nginx-deploy --replicas=3
kubectl get all
```

### Version Control (GitHub)

**Repo:** https://github.com/DaniaBdour/progresssoft-assignment

```bash
# Upload
git add .
git commit -m 'message'
git push origin main

# Download
git pull origin main
```

**Common Git Commands:**

| Command | Description |
|---------|-------------|
| git init | Initialize new repository |
| git clone URL | Download repository |
| git add . | Stage all changes |
| git commit -m 'msg' | Save snapshot |
| git push origin main | Upload to GitHub |
| git pull origin main | Download latest |
| git log --oneline | View commit history |
| git status | Show changed files |
| git branch | List branches |

---

## Key Concepts

### RAID

| Level | Description | Redundancy |
|-------|-------------|------------|
| RAID 0 | Striping | None — one disk failure = total loss |
| RAID 1 | Mirroring | Full — survives 1 disk failure |
| RAID 5 | Stripe + Parity | Survives 1 disk failure, needs 3+ disks |
| RAID 6 | Double Parity | Survives 2 disk failures, needs 4+ disks |
| RAID 10 | Mirror + Stripe | Best performance + redundancy, needs 4+ disks |

### DevOps

DevOps is a culture and set of practices that combines software development (Dev) and IT operations (Ops). Key practices: CI/CD, Infrastructure as Code, monitoring, automation, and collaboration.

### High Availability (HA) and Disaster Recovery (DR)

**HA:** Designing systems to minimize downtime. Uses redundancy so no single component failure takes down the system. Measured in nines: 99.99% = 52 minutes downtime/year.

**DR:** Planning for recovery after a catastrophic event.
- RPO (Recovery Point Objective): maximum data loss acceptable
- RTO (Recovery Time Objective): maximum downtime acceptable

**Technologies:**
- PostgreSQL: Streaming replication, Patroni
- Oracle: RAC, Data Guard
- Tomcat: Session replication, HAProxy load balancing

### Cloud Computing

| Type | Who manages | Examples |
|------|-------------|---------|
| IaaS | You manage OS and up | AWS EC2, Azure VMs |
| PaaS | You manage app only | Heroku, AWS Beanstalk |
| SaaS | Provider manages all | Gmail, Office 365, Zoom |

**Cloud types:** Public (AWS, Azure, GCP), Private (dedicated), Hybrid (mix), Multi-Cloud (multiple providers)

### DNS

DNS translates domain names to IP addresses. Key record types:

| Record | Purpose |
|--------|---------|
| A | Domain → IPv4 address |
| AAAA | Domain → IPv6 address |
| CNAME | Alias → another domain |
| MX | Mail server for domain |
| TXT | Verification, SPF, DKIM |
| NS | Authoritative nameservers |

### Load Balancers

**Algorithms:**
- Round Robin: requests go to each server in sequence
- Least Connections: new request goes to least busy server
- IP Hash: same client always goes to same server
- Weighted: servers with higher weight get more traffic

**Layer 4 vs Layer 7:**
- Layer 4: routes by IP/port, very fast, cannot inspect content
- Layer 7: routes by HTTP path/headers/cookies, smarter routing

**Tools:** HAProxy, Nginx, AWS ALB/NLB, F5

---

## Screenshots

All screenshots are in the `screenshots/` folder showing proof of completion for every task.

---

*ProgressSoft Assignment — Dania Bdour — March 2026*
