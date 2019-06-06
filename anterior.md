# examen servidor pop aws  
## roberto altamirano martinez


#### arquitectura 

en un cloud de amazon, tendremos activo nuestro servidor en un docker 
el cual contendra la bustia de entrada de correos de cada usuario (pere, marta)

#### comenzaremos por la configuracion de aws

arrancamos una instancia en amazon cloud y conectamos.

```
[isx47262285@i15 ~]$ ssh -i examen_key.pem fedora@18.130.196.96
```

haremos las instalaciones necesarias:

nos convertimos en root
```
[fedora@ip-172-31-22-139 ~]$ sudo /bin/bash
```

instalaciones:

```
[root@ip-172-31-22-139 fedora]# dnf -y install nmap docker xinetd  telnet
```

crearemos un docker automatizado en detach

docker basado en nethost con los servicios del paquete iw-imap, creamos la imagen:
```
docker build -t robert72004/m11roberto:latest .
```

creamos la red del docker y arrancamos el docker con los puertos del pop3  i pop3s

```
# docker network create popnet

[root@ip-172-31-22-139 m11Roberto]# docker run --rm --name popserver -h popserver --network popnet --privileged -p 110:110 -p 995:995 -d robert72004/m11roberto:latest

```

desde dentro del docker comprovamos los puertos abiertos

```
[root@ip-172-31-22-139 fedora]# docker exec -it popserver /bin/bash
[root@popserver docker]# nmap localhost
```

los puertos 110 y 995 estan abiertos 

-----------------------------------------------------------------------

### CREACIO DE CONECTIVIDAD 

para conectarnos a nuestro servidor de correo tenemos que crear un tunelssh desde el host-local
es decir (i15 en mi caso) hasta el servidor AWS.

```
[isx47262285@i15 ~]$ ssh -i examen_key.pem -L 50000:localhost:110 
```

este tunel esta creado para conectarnos al puerto 110 en remoto que a su vez esta
mapeado contra el docker con el servidor pop en el puerto 110

ojo se puede mejorar  sin mapear puerto.... se entiende que no es lo importante, pero 
podriamos editar el /etc/hosts para conectarnos si mapear puertos.

-----------------------------------------------------------------------

####  interaccion desde el host local

desde local actacamos contra nuestro puerto 50000 que tiene la conectividad al servidor pop en amazon 

```
[isx47262285@i15 ~]$ telnet localhost 50000
Trying ::1...
Connected to localhost.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 0 messages
^]   
telnet> quit
Connection closed.
```

-----------------------------------------------------------------------------------


en mi caso personal, tengo un problema con el planchado del mailbox de los usuarios.
por alguna razon tonta al copiarlos en el fichero '/var/spool/mail/user' (todo despues de añadir los usuarios)
resulta que no los plancha correctamente lo que nos hace pensar en primera instancia que nuestro servidor no va.....

Para comprovar que todo el trabajo hasta ahora si funciona haremos el planchado del mail box manualmente.

###### desde el host aws

entramos en el docker en una session interactiva de consola.

```
[root@ip-172-31-22-139 fedora]# docker exec -it popserver /bin/bash

[root@popserver docker]# cp pere /var/spool/mail/pere 
cp: overwrite '/var/spool/mail/pere'? y

```

una vez planchado el mailbox podemos provar desde dentro del host-aws que funciona 
y despues haremos lo mismo desde fuera.

```

[root@ip-172-31-22-139 m11Roberto]# telnet localhost 110
Trying ::1...
Connected to localhost.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 3 messages
```

comprovamos que existen los correos pertinente en el usuario pere 

haremos lo mismo desde fuera 
```
[isx47262285@i15 ~]$ telnet localhost 50000
Trying ::1...
Connected to localhost.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 3 messages
```

comprovamos que todo funciona. asi que el servidor esta funcionando correctamente 


```
[isx47262285@i15 ~]$ telnet localhost 50000
Trying ::1...
Connected to localhost.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 3 messages
RETR 1
+OK 394 octets
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

.
RETR 2
+OK 395 octets
Return-Path: <isx47262285@i15.informatica.escoladeltreball.org>
From: isx47262285 <isx47262285@i15.informatica.escoladeltreball.org>
Date: Fri, 16 Mar 2018 12:39:21 +0100
To: pere@i15.informatica.escoladeltreball.org,
        hola@i15.informatica.escoladeltreball.org
Subject: Hola
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Status: RO

adios


```

