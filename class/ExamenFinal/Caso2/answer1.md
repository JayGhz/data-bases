### Data Model Pattern
#### Eventos
- El campo lugar es documento embebido que contiene los datos del lugar donde se realiza el evento.

#### Detalle_Eventos
- El  campo  oradores  un  arreglo  de  documentos  embebidos  que  contiene  los  datos  de  los  oradores  que 
participan en el evento.
- El campo patrocinadores un arreglo de documentos embebidos que contiene los datos de los 
patrocinadores que auspician el evento. 
- El  campo  empresa  es  un  documento  embebido  que  contiene  los  datos  de  la  empresa  que  organiza  el 
evento. 

#### Subset pattern (documento embebido) 
La colección eventos es un subconjunto de la colección detalle_eventos. La colección muestra los datos 
más  relevantes  de  cada  evento,  mientras  que  la  colección  detalle_eventos  muestra  el  detalle  de  cada 
evento. 
 
#### Reference pattern 
Por cada documento de la colección evento existe un documento en la colección detalle_eventos, dado 
que se trata del mismo evento. Para ello se requiere que en cada documento de la colección 
detalle_eventos haya una referencia al documento correspondiente en la colección eventos.