# m11extraRoberto
## nombre: Roberto Altamirano Martinez
## isx47262285
### descripcion:

servidor pop situado en un cloud de amazon que contiene
el buzon de correo de los usuarios pere y marta.

------------------------------------------------------------------------

# Pasos a seguir

1. accedemos a amazon cloud y lanzamos una instancia para trabajar

```
[isx47262285@i15 ~]$ ssh -i examen_key.pem fedora@3.8.127.122
```

2. hacemos las instalaciones necesarias: docker nmap telnet 

```
sudo /bin/bash 

[root@ip-172-31-22-244 fedora]# dnf -y install docker nmap telnet git
```

3. gestion del firewall de amazon 

en este caso debemos configurar el firewall, vamos a editar las reglas 
para que nos de acceso al puerto 110(pop) y 995 (pops)


4. nuestro repositorio en github.com/isx47262285/m11extraRoberto

en este repositorio encontraremos todos los ficheros necesarios para 
crear nuestra imagen docker que contendra dicho servidor pop.

5. descargamos en amazon aws nuestro repositorio configurado. 

una vez hecho el clone:

```
git clone https://github.com/isx47262285/m11extraRoberto.git
```
aqui tenemos todo lo que hace falta para la imagen docker 

```
[root@ip-172-31-22-244 fedora]# cd m11extraRoberto/
[root@ip-172-31-22-244 m11extraRoberto]# ll
total 112
-rw-r--r--. 1 root root    20 Jun  6 07:50 adjunto.pdf
-rw-r--r--. 1 root root   342 Jun  6 07:50 Dockerfile
-rw-r--r--. 1 root root 68064 Jun  6 07:50 imagen.jpg
-rw-r--r--. 1 root root   313 Jun  6 07:50 install.sh
-rw-r--r--. 1 root root  1393 Jun  6 07:50 marta
-rw-r--r--. 1 root root  1393 Jun  6 07:50 pere
-rw-r--r--. 1 root root  1104 Jun  6 07:50 README.md
-rw-r--r--. 1 root root   105 Jun  6 07:50 startup.sh
drwxr-xr-x. 3 root root  4096 Jun  6 07:50 xinetd.d
-rw-r--r--. 1 root root  2394 Jun  6 07:50 xinetd.tgz

```

los ficheros "pere" y "marta" contienen el mailbox de cada usuario.


activamos el servico docker y creamos nuestra red de docker:

```
[root@ip-172-31-22-244 m11extraRoberto]# systemctl start docker
[root@ip-172-31-22-244 m11extraRoberto]# docker network create popnet
66ba88bfd2b4ee9d58597dcf0fdb7476722471f9cf98a1885a6fc1dc5b89b017
```

crearemos nuestra imagen docker basada en fedora:27 definida por Dockerfile

```
docker build -t robert72004/m11extraroberto .
```

## Ejecucion del docker
```
[root@ip-172-31-22-244 m11extraRoberto]# docker run --rm --name popserver -h popserver --privileged --network popnet -p 110:110 -p 995:995 -d robert72004/m11extraroberto
```

comprobamos que el docker esta corriendo y los puertos estan mapeados y abiertos

```
[root@ip-172-31-22-244 m11extraRoberto]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                        NAMES
017e4c8f3faa        1e486db62925        "/opt/docker/start..."   14 minutes ago      Up 14 minutes       0.0.0.0:110->110/tcp, 0.0.0.0:995->995/tcp   popserver
```

una vez hecho este paso , pasamos a las comprovaciones.

### desde amazon 

```

[root@ip-172-31-22-244 m11extraRoberto]# telnet localhost 110
Trying ::1...
Connected to localhost.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 3 messages
LIST
+OK Mailbox scan listing follows
1 889
2 395
3 893
.
RETR 1
+OK 889 octets
Return-Path: <isx47262285@i15.informatica.escoladeltreball.org>
From: isx47262285 <isx47262285@i15.informatica.escoladeltreball.org>
Date: Fri, 16 Mar 2018 12:39:21 +0100
To: pere@i15.informatica.escoladeltreball.org,
        hola@i15.informatica.escoladeltreball.org
Subject: Hola
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Status: RO

adeu

--000000000000f5e408058aa3499d--
--000000000000f5e40c058aa3499f
Content-Type: application/pdf; name="adjunto.pdf"
Content-Disposition: attachment; filename="adjunto.pdf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jwkdw17i1
Content-ID: <f_jwkdw17i1>


--000000000000f5e40c058aa3499f
Content-Type: image/jpeg; name="imagen.jpg"
Content-Disposition: attachment; filename="imagen.jpg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jwkdw16x0
Content-ID: <f_jwkdw16x0>
.
```

## DESDE FUERA (AULA DE CLASE )

```
[isx47262285@i15 m11extraRoberto]$ telnet 3.8.127.122 110
Trying 3.8.127.122...
Connected to 3.8.127.122.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 3 messages
LIST
+OK Mailbox scan listing follows
1 889
2 395
3 893
.
RETR 1
+OK 889 octets
Return-Path: <isx47262285@i15.informatica.escoladeltreball.org>
From: isx47262285 <isx47262285@i15.informatica.escoladeltreball.org>
Date: Fri, 16 Mar 2018 12:39:21 +0100
To: pere@i15.informatica.escoladeltreball.org,
        hola@i15.informatica.escoladeltreball.org
Subject: Hola
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Status: RO

adeu

--000000000000f5e408058aa3499d--
--000000000000f5e40c058aa3499f
Content-Type: application/pdf; name="adjunto.pdf"
Content-Disposition: attachment; filename="adjunto.pdf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jwkdw17i1
Content-ID: <f_jwkdw17i1>


--000000000000f5e40c058aa3499f
Content-Type: image/jpeg; name="imagen.jpg"
Content-Disposition: attachment; filename="imagen.jpg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jwkdw16x0
Content-ID: <f_jwkdw16x0>
.

```

### AMB EL USUARI MARTA

```

[isx47262285@i15 m11extraRoberto]$ telnet 3.8.127.122 110
Trying 3.8.127.122...
Connected to 3.8.127.122.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER marta
+OK User name accepted, password please
PASS marta
+OK Mailbox open, 3 messages
LIST 
+OK Mailbox scan listing follows
1 889
2 395
3 893
.
RETR 1
+OK 889 octets
Return-Path: <isx47262285@i15.informatica.escoladeltreball.org>
From: isx47262285 <isx47262285@i15.informatica.escoladeltreball.org>
Date: Fri, 16 Mar 2018 12:39:21 +0100
To: pere@i15.informatica.escoladeltreball.org,
        hola@i15.informatica.escoladeltreball.org
Subject: Hola
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Status: RO

adeu

--000000000000f5e408058aa3499d--
--000000000000f5e40c058aa3499f
Content-Type: application/pdf; name="adjunto.pdf"
Content-Disposition: attachment; filename="adjunto.pdf"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jwkdw17i1
Content-ID: <f_jwkdw17i1>


--000000000000f5e40c058aa3499f
Content-Type: image/jpeg; name="imagen.jpg"
Content-Disposition: attachment; filename="imagen.jpg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jwkdw16x0
Content-ID: <f_jwkdw16x0>
.
    




