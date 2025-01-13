# Challenge

## Challenge 1

Objetivo: Cumplir una serie de restricciones

##### Evitar pods en nodos determinados

Solución: Añadir un nodeSelector, modificamos chart de helm (el deployment.yaml) para que recoga los valores que le indicamos en el values. El valor que indicamos en el yaml es el grupo el cual se va a evitar en el momento del despliegue de los pods.

##### Evitar un pod desplegado en un nodo donde hay un pod igual

Solución: Suponemos un micro de frontend el cual queremos que solo haya un pod por nodo, usaremos la Antiafinidad para evitar que hayan dos pods con el mismo label. Para indicar que sean en el mismo nodo especificaremos la topologia hostname.

##### Evitar un pod desplegado en la misma zona

Solución: Usamos el mismo metodo previo pero, en este caso la topología será por zona

#### Esperar a un servicio random

Solución: Aprovechamos los init containers para esperar a que un serivico con un nombre "x" y un puerto "y" se despliegue antes de que apliquemos los manifiestos.
Básicamente lo que indicamos es que ejecutamos un comando netcat el cual va a estar "preguntando" al servicio y puerto indicados si esta activo, cada 5 segundos, en cuanto este activo el contenedor muere y ya se ejecuta el contenedor que aplica los manifiestos.

### Archivos modificados: values.yaml - deployment.yaml

## Challenge 2

Objetivo: Automatizar el proceso de copiar charts de Helm de un registro de GCP referencia a uno "instancia"

Solución: Para ello, definimos un archivo main el cual llama al modulo "copy_charts" y le comparte los charts que han de ser copiados.
Por otra parte, el modulo "copy_charts" lo que hace es ir descargando del registro referencia los diferentes charts que se han definido y "pusheandolos" a el registro objetivo

## Challenge 3

Objetivo: Hacer un workflow el cual copie los archivos del registro de referencia al objetivo con el modulo creado en el Challenge 2 y que posteriormente instale el Chart de helm del Challenge 1 en el cluster de GKE (Tomamos como referencia que el chart esta en el registro de artefactos referencia)

Solución: Generamos un workflow el cual configure el SDK de google cloud y se identifique, prepare helm y terraform, ejecute la automatización de terraform y despliegue el chart en el cluster.

Importante: Las variables de entorno se configuran como secretos.
