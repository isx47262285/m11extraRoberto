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

3. creamos nuestro repositorio en github.com/isx47262285/m11extraRobertoll

en este repositorio encontraremos todos los ficheros necesarios para 
crear nuestra imagen docker que contendra dicho servidor pop.

4. creacion de docker

una vez hecho el clone:

```
git clone https://github.com/isx47262285/m11extraRoberto.git
```

crearemos nuestra imagen docker basada en fedora:27 definida por Dockerfile

```
docker build -t robert72004/m11extraroberto .
```

por otra parte crearemos nuestra red internat popnet

```


