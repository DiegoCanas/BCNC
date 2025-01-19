# Challenge

El objetivo de esta prueba es la resolción de tres challenges relacionados entre si.

## Estructura de la prueba

```plaintext
.
├── Challenge1
│ └── ping
│ ├── Chart.yaml
│ ├── templates
│ │ ├── deployment.yaml
│ │ ├── \_helpers.tpl
│ │ ├── hpa.yaml
│ │ ├── ingress.yaml
│ │ ├── NOTES.txt
│ │ ├── serviceaccount.yaml
│ │ ├── service.yaml
│ │ └── tests
│ │ └── test-connection.yaml
│ └── values.yaml
├── Challenge2
│ ├── main.tf
│ ├── modules
│ │ └── copy_helm_charts
│ │ ├── main.tf
│ │ └── variables.tf
│ ├── outputs.tf
│ ├── terraform.tfstate
│ ├── terraform.tfstate.backup
│ ├── terraform.tfvars
│ └── variables.tf
├── Challenge3
│ └── .github
│ └── workflows
│ └── helm-deploy.yaml
└── README.md
```

## Challenge 1

Objetivo: Cumplir una serie de restricciones

#### Evitar pods en nodos determinados

Solución: Añadir un nodeSelector, modificamos chart de helm (el deployment.yaml) para que recoga los valores que le indicamos en el values. El valor que indicamos en el yaml es el grupo el cual se va a evitar en el momento del despliegue de los pods.

#### Evitar un pod desplegado en un nodo donde hay un pod igual

Solución: Suponemos un micro de frontend el cual queremos que solo haya un pod por nodo, usaremos la Antiafinidad para evitar que hayan dos pods con el mismo label. Para indicar que sean en el mismo nodo especificaremos la topologia hostname.

#### Evitar un pod desplegado en la misma zona

Solución: Usamos el mismo metodo previo pero, en este caso la topología será por zona

#### Esperar a un servicio random

Solución: Aprovechamos los init containers para esperar a que un serivico con un nombre "x" y un puerto "y" se despliegue antes de que apliquemos los manifiestos.
Básicamente lo que indicamos es que ejecutamos un comando netcat el cual va a estar "preguntando" al servicio y puerto indicados si esta activo, cada 5 segundos, en cuanto este activo el contenedor muere y ya se ejecuta el contenedor que aplica los manifiestos.

#### Ejecución

Para instalar este chart de helm en el cluster hay que ejecutar los siguientes comandos:

helm repo add {nombre-registro} {url-registro}  
helm repo update  
helm install {nombre-release} {nombre-repo}/{chart-nombre} --namespace {nombre-namespace}

Ej:

helm repo add instance registro www.registro.io  
helm repo update  
helm install ping registro/ping --version 0.1.0

#### Archivos modificados: values.yaml - deployment.yaml

## Challenge 2

Objetivo: Automatizar el proceso de copiar charts de Helm de un registro de GCP referencia a uno "instancia"

Solución: Para ello, definimos un archivo main el cual llama al modulo "copy_charts" y le comparte los charts que han de ser copiados.
Por otra parte, el modulo "copy_charts" lo que hace es ir descargando del registro referencia los diferentes charts que se han definido y "pusheandolos" a el registro objetivo

Estructura:

Challenge 2

- main.tf: Esta escrita la lógica principal que sigue terraform, se llama al proveedor y se declara el módulo que se va a ejecutar
- outputs.tf: Escribe un output de los charts copiados
- terraform.vars: Definición de una serie de valores para las variables.
- variables.tf: Definición de las variables que se utilizan en el archivo main.tf

El objetivo con esta estructura es buscar que el código sea sencillo de leer, escalable en el futuro y reutilizable. El hacerlo de forma modular nos acerca a este tipo de objetivo.

#### Ejecución

terraform init  
terraform plan  
terraform apply

## Challenge 3

Objetivo: Hacer un workflow el cual copie los archivos del registro de referencia al objetivo con el modulo creado en el Challenge 2 y que posteriormente instale el Chart de helm del Challenge 1 en el cluster de GKE (Tomamos como referencia que el chart esta en el registro de artefactos referencia)

Solución: Generamos un workflow el cual configure el SDK de google cloud y se identifique, prepare helm y terraform, ejecute la automatización de terraform y despliegue el chart en el cluster.

Importante: Las variables de entorno se configuran como secretos.

#### Variables de entorno

- `PROJECT_ID`: ID del proyecto donde se trabaja en GCP
- `GKE_CLUSTER`: Nombre del cluster de GKE
- `GKE_ZONE`: Zona de disponibilidad del GKE
- `GCP_SA_KEY`: Clave de la cuenta de servicio para identificarse en GCP

#### Ejecución

La ejecución se realiza cuando existe un push a master, pero, para que pueda ser detectada ha de estar la carpeta .github/workflows en la raiz del proyecto
