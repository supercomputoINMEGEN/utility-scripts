# Instrucciones para crear un nuevo grupo  

## En Indra (contiene el zfs cajon/labs/ )

1. Descargar este git  
2. Revisar el padron de usuarios y grupos de supercomputo  
3. Llenar las siguientes variables en un bloc de notas o texto plano  

```
_GID=#9999
_GNAME=#"elgrupo"
_CREATEZFS=yes
_QUOTA=#"50G"
```



4. Ejecutar la siguiente línea

```
sudo bash create-group.sh -G "$_GID" -g "$_GNAME" -c "$_CREATEZFS" -z cajon/labs/"_GNAME" -q "$_QUOTA" -m /labs/"_GNAME"
```

