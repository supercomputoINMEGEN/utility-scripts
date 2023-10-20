# Instrucciones para crear un nuevo grupo ==  

## En Indra (contiene el zfs cajon/labs/ )

1. Descargar este git  
2. Revisar el padron de usuarios y grupos de supercomputo para definir que _GID y _GNAME le toca  
3. Llenar las siguientes variables en un bloc de notas o texto plano  

```
_GID=#9999
_GNAME=#"elgrupo"
_CREATEZFS=yes
_QUOTA=#"50G"
```

4. Ejecutar la siguiente línea

```
sudo bash create-group.sh -G "$_GID" -g "$_GNAME" -c "$_CREATEZFS" -z cajon/labs/"$_GNAME" -q "$_QUOTA" -m /labs/"$_GNAME" && getent group "$_GNAME"
```

5. Exportar el labs desde indra. Ejecutar `sudo nano /etc/exports` . Por ejemplo agregar en la última línea:    

```
/labs/scbio central(rw,sync,no_subtree_check,no_root_squash)    notron(rw,sync,no_subtree_check,no_root_squash)
```

5. Reinicar el servicio de exporte

```
sudo systemctl restart nfs-kernel-server && sudo exportfs -v | grep "$_GNAME"
```
## En todos los demás nodos

7. Llenar las siguientes variables en un bloc de notas o texto plano  
*NOTA:* En los nodos NO CREA UN ZFS, por eso _CREATEZFS=no    

```
_GID=#9999
_GNAME=#"elgrupo"
_CREATEZFS=no
```

8. Ir al directorio de trabajo local de https://github.com/supercomputoINMEGEN/utility-scripts/tree/main/create-group-or-user    

9. Ejecutar las siguientes líneas:  

```
sudo mkdir /labs/"$_GNAME" \
&& sudo bash create-group.sh -G "$_GID" -g "$_GNAME" \
&& getent group "$_GID"
```

10. Importar el labs que viene de indra. Ejecutar `sudo nano /etc/auto.labs` . Por ejemplo agregar en la última línea:    

```
/labs/scbio -fstype=nfs indra:/labs/scbio
```

11. Reinicar el servicio de autofs    

```
sudo systemctl restart autofs && mount -t autofs | grep "$_GNAME"
```

# Instrucciones para crear un nuevo usuario ==  

## En Central (contiene el zfs los_homes/ )  

1. Descargar este git  
2. Revisar el padron de usuarios y grupos de supercomputo, para definir que UID y UNAME le toca  
2. Revisar que el grupo al que se va a asignar ya existe en el server   
3. Llenar las siguientes variables en un bloc de notas o texto plano  

```
_UID=#1501
_UNAME=#"elusuario"
_GNAME=#"elgrupo"
_EXPIRE=#"YYYY-MM-DD"
_SHELL=#"yes\no" # yes = /bin/bash  no = no permitir el login por shell
_CREATEZFS=#"yes\no" # yes = se creara un zfs en los_homes/* (solo usar en central)
_QUOTA=#"50G"
```

4. Ejecutar la siguiente línea

```
sudo bash create-user.sh -G "$_GNAME" -i "$_UID" -u "$_UNAME" -d "$_EXPIRE" -s "$_SHELL" -c "$_CREATEZFS" -z los_homes/"$_UNAME" -q "$_QUOTA" \
&& id "$_UID" \
&& sudo -u "$_UNAME" bash -c 'bash /home/programs/miniconda_installer/Miniconda3-latest-Linux-x86_64.sh -b && ~/miniconda3/bin/conda init bash && cd ~ && nextflow -h'
```

5. Exportar el home desde Central. Ejecutar `sudo nano /etc/exports` . Por ejemplo agregar en la última línea:    

```
/home/iaguilar  indra(rw,sync,no_subtree_check,no_root_squash)  notron(rw,sync,no_subtree_check,no_root_squash)

```

5. Reinicar el servicio de exporte     

```
sudo systemctl restart nfs-kernel-server && sudo exportfs -v | grep "$_UNAME"
```

## En todos los demás nodos

7. Llenar las siguientes variables en un bloc de notas o texto plano  

*NOTA:* En los nodos NO CREA UN ZFS, por eso _CREATEZFS=no    

*NOTA:* En los nodos NO SE PERMITE LOGIN SSH, por eso _SHELL=no    

```
_UID=#1501
_UNAME=#"elusuario"
_GNAME=#"elgrupo"
_EXPIRE=#"YYYY-MM-DD"
_SHELL="no"
_CREATEZFS="no"
```

8. Ir al directorio de trabajo local de https://github.com/supercomputoINMEGEN/utility-scripts/tree/main/create-group-or-user    

9. Ejecutar las siguientes líneas:  

```
sudo mkdir /home/"$_UNAME" \
&& sudo bash create-user.sh -G "$_GNAME" -i "$_UID" -u "$_UNAME" -d "$_EXPIRE" -s no -c no \
&& id "$_UID"
```

10. Importar el home que viene de Central. Ejecutar `sudo nano /etc/auto.homes` . Por ejemplo agregar en la última línea:    

```
/home/iaguilar  -fstype=nfs central:/home/iaguilar
```

11. Reinicar el servicio de autofs    

```
sudo systemctl restart autofs && mount -t autofs | grep "$_UNAME"
```
