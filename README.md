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
docker build -t robert72004/m11extraroberto:latest .
docker build -t robert72004/m11extraroberto:v1 .
```

## Ejecucion del docker
```
docker run --rm --name popserver -h popserver --network popnet --privileged -p 110:110 -p 995:995 -d robert72004/m11extraroberto:latest 
```


comprobamos que el docker esta corriendo y los puertos estan mapeados y abiertos

```
[root@ip-172-31-22-244 m11extraRoberto]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                        NAMES
017e4c8f3faa        1e486db62925        "/opt/docker/start..."   14 minutes ago      Up 14 minutes       0.0.0.0:110->110/tcp, 0.0.0.0:995->995/tcp   popserver
```

### una vez hecho este paso , pasamos a las comprovaciones.


## DESDE FUERA (AULA DE CLASE )
### servei pop 

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


```

## POPS DE
### CONEXION AMB POPS
```
[isx47262285@i15 ~]$ openssl s_client -connect 3.8.127.122:995
CONNECTED(00000003)
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify error:num=18:self signed certificate
verify return:1
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify return:1
---
Certificate chain
 0 s:/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
   i:/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIETjCCAzagAwIBAgIJANUy7KTLixzrMA0GCSqGSIb3DQEBCwUAMIG7MQswCQYD
VQQGEwItLTESMBAGA1UECAwJU29tZVN0YXRlMREwDwYDVQQHDAhTb21lQ2l0eTEZ
MBcGA1UECgwQU29tZU9yZ2FuaXphdGlvbjEfMB0GA1UECwwWU29tZU9yZ2FuaXph
dGlvbmFsVW5pdDEeMBwGA1UEAwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkwJwYJ
KoZIhvcNAQkBFhpyb290QGxvY2FsaG9zdC5sb2NhbGRvbWFpbjAeFw0xOTA2MDYw
NzMzNDlaFw0yMDA2MDUwNzMzNDlaMIG7MQswCQYDVQQGEwItLTESMBAGA1UECAwJ
U29tZVN0YXRlMREwDwYDVQQHDAhTb21lQ2l0eTEZMBcGA1UECgwQU29tZU9yZ2Fu
aXphdGlvbjEfMB0GA1UECwwWU29tZU9yZ2FuaXphdGlvbmFsVW5pdDEeMBwGA1UE
AwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkwJwYJKoZIhvcNAQkBFhpyb290QGxv
Y2FsaG9zdC5sb2NhbGRvbWFpbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMHYKAyiy9QDYwyiYLRYurQXzJ2stiAdn/FfHVfGYf4vzpyTmBsSnkbcUteG
l3CB+4iebFrkrGYtvT1z13NrHSrAdCo+VxDO+Km073x9ysooc3xdnjfQd7UquUpI
YPq7qJFSPDjstNafKAIc++lCKbSgTLFUYQbWtqNIjS9FPLeNVsE9Iw8r0A8Yzny9
wz9T65riV63ElKjVVTXX0bEyvZ8y7c79boiZxlqO7tZHWzp+Lci4X2GHsGDn3pbF
vrMrH+Ssm9AYVASU0bsHtYi3Kn8VnwjWkUAgNOhHniXXE/4/mG7RISiqGZ520/Z0
b7CTkOSKlLkp+qpavcCYKF0bN68CAwEAAaNTMFEwHQYDVR0OBBYEFOFYdkrNodY2
avnzwbVWe/UBXyN3MB8GA1UdIwQYMBaAFOFYdkrNodY2avnzwbVWe/UBXyN3MA8G
A1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAI5QKwJdLHfJLmKjAv9U
DdfcNOY8yMZlXjx6UrcHVxWUfwd+WUvHqnNq5efsaLUdWqGwK0xg3CEiCYCy8Cwq
x0o7DHrMWxMuwOdNk1ScUEZ9Z69r5eqAd22DfIealTJVtG4ze9aLoEjfSulFTYRj
kmQpyyt/AodawGPCYVRPdXLrODL7bbNW16Jl4A8kN+g1m3wDo2sM/m118mSawHPi
YrCt/6V3234QIMyNvAzHrmz2XqkqdwiyGj2QrxmiIAg8vwBCII8hVsEumDbdQ8k7
3KHVv4vvsa7sRRx2olBLT4DOH1S5TNccfVz6OMQ9JMOI3oyq8CPQDolPBjh+/mAa
2Cs=
-----END CERTIFICATE-----
subject=/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
issuer=/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
---
No client certificate CA names sent
Peer signing digest: SHA512
Server Temp Key: X25519, 253 bits
---
SSL handshake has read 1731 bytes and written 347 bytes
Verification error: self signed certificate
---
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: 009A7B737C5DE63C18D01788EBA56E69E9322199664F0CF33AF81010399DC7A9
    Session-ID-ctx: 
    Master-Key: CA30C5299AA427E71CFCCF8B65708C91161084AB5C2753E42D82D58F9298800E8B2D31B19C531CF308C40D44DDBB3389
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    TLS session ticket lifetime hint: 7200 (seconds)
    TLS session ticket:
    0000 - 61 9e da 62 74 88 b5 90-ef 38 4e 2c d2 4d 9f 62   a..bt....8N,.M.b
    0010 - 5b cb 9e 40 ab af a9 f3-4e 9a 6d b7 7c e6 56 4c   [..@....N.m.|.VL
    0020 - bb 82 c9 57 69 b2 d1 e7-68 94 67 89 8e dd 25 bd   ...Wi...h.g...%.
    0030 - 92 91 48 a5 5e 3f 00 4b-df 7f 06 cf fd 66 7d 16   ..H.^?.K.....f}.
    0040 - 22 9a f9 a0 b5 7a b7 93-e0 fa e4 60 38 a0 52 2c   "....z.....`8.R,
    0050 - 5e 63 f1 6d 00 59 36 35-8b a2 dd 97 31 f8 4e d3   ^c.m.Y65....1.N.
    0060 - e9 37 d2 a6 fa 8f 96 ff-bf 65 4c 5a 31 6d 7b 2a   .7.......eLZ1m{*
    0070 - 2e 37 aa ed d6 4c 49 22-13 b4 92 27 c4 9d 65 33   .7...LI"...'..e3
    0080 - 2b a9 28 4d 1b f9 c8 ac-29 51 3c 7f e4 0d 47 40   +.(M....)Q<...G@
    0090 - af 09 a1 80 9b a1 85 f1-9b 69 91 20 83 b9 25 e9   .........i. ..%.

    Start Time: 1559812337
    Timeout   : 7200 (sec)
    Verify return code: 18 (self signed certificate)
    Extended master secret: yes
---
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
RENEGOTIATING
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify error:num=18:self signed certificate
verify return:1
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify return:1

```

EN EL CASO DE MARTA:


```
---
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
RENEGOTIATING
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify error:num=18:self signed certificate
verify return:1
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify return:1
1
-ERR Unknown TRANSACTION state command

-ERR Null command
OK
-ERR Unknown TRANSACTION state command
QUIT
DONE
```


> COMO PODEMOS COMPROBAR EL ACCESO HASTA EL SERVIDOR POP3S ES CORRECTO, TENEMOS ACCESO COMO USUARIOS "PERE" Y "MARTA" PODEMOS LISTAR EL MAILBOX  PERO CUANDO QUEREMOS DESCARGAR UN CORREO NOS DA PROBLEMAS CON EL CERTIFICADO.

el servidor funciona correctamente.




