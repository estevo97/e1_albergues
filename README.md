## 1. Descargar o proxecto

Clona o repositorio e accede ao seu directorio:

```bash
git clone <URL_DEL_REPOSITORIO>
cd e1-albergues
```

Substitue `<URL_DEL_REPOSITORIO>` pola URL do teu repositorio de GitHub.

## 2. Configurar as variables de entorno

Copia o arquivo de exemplo para crear a túa configuración local:

```bash
cp .env.example .env
```

Edita `.env` e establece os valores de `POSTGRES_DB`, `POSTGRES_USER` e `POSTGRES_PASSWORD`.

- POSTGRES_DB=albergues
- POSTGRES_USER=admin_albergues
- POSTGRES_PASSWORD=a_tua_contrasinal_segura

## 3. Arrancar os servizos

Dende a raíz do proxecto, onde se encuentra o arquivo `compose.yaml`, executa:

```bash
docker compose up -d
```

Este comando crea e inicia os contedores de PostgreSQL e Adminer en segundo plano.

Durante a primera inicialización de PostgreSQL, execútanse os scripts SQL da carpeta `initdb/` para crear a táboa `albergues` e inserir os datos iniciais.

Adminer arrancará cando PostgreSQL esté dispoñible e superase a súa comprobación de saúde (*healthcheck*).

## 4. Comprobar o estado dos servizos

Para comprobar o estado dos contedores, executa:

```bash
docker compose ps
```

Verifica que PostgreSQL aparezca como `healthy` y que el contenedor de Adminer esté iniciado. A saída que terías que ver sería similar a esta:

NAME                  IMAGE         STATUS
e1-albergues-db-1     postgres:17   Up (healthy)
e1-albergues-adminer-1 adminer:4     Up

## 5. Acceder a Adminer

Abre [http://localhost:8080](http://localhost:8080) no navegador e introduce os siguientes datos:

| Campo | Valor |
|---|---|
| Sistema | PostgreSQL |
| Servidor | `db` |
| Usuario | O valor de `POSTGRES_USER` definido en `.env` |
| Contrasinal | O valor de `POSTGRES_PASSWORD` definido en `.env` |
| Base de datos | O valor de `POSTGRES_DB` definido en `.env` |

Unha vez conectado, poderás consultar a táboa `albergues` e comprobar que se cargaron os rexistros iniciais.

## 6. Proba de persistencia

Esta proba permite comprobar que os datos de PostgreSQL poden ser conservados ou eliminados en función do que se faga co volume persistente.

| **Paso** | **Comando ou acción** | **Resultado esperado** |
|---|---|---|
| 1 | `docker compose up -d` | Inícianse os servizos e cárganse os datos iniciais de `initdb/` se o volume se crea por primeira vez. |
| 2 | Inserir un albergue novo desde Adminer | O novo albergue queda gardado na táboa `albergues`. |
| 3 | `docker compose down` e despois `docker compose up -d` | Os contedores reinícianse e o albergue engadido segue existindo. |
| 4 | `docker compose down -v` e despois `docker compose up -d` | Elimínase o volume de datos. PostgreSQL crea unha base de datos nova e executa de novo os scripts de inicialización; o albergue engadido no paso 2 xa non aparece. |

### Por que o resultado do paso 4 é distinto?

No paso 3, `docker compose down` elimina os contedores, pero conserva o volume con nome `postgres_data`, onde PostgreSQL almacena os datos. Por iso, ao volver iniciar os servizos, os cambios realizados permanecen.

No paso 4, a opción `-v` elimina tamén os volumes definidos no proxecto. Ao executar de novo `docker compose up -d`, PostgreSQL inicializa unha base de datos nova e executa os scripts SQL de `initdb/`. Os datos iniciais recupéranse, pero os albergues engadidos posteriormente pérdense.

A diferenza está en se decides eliminar ou deixar os volumes. Con `docker compose down` eliminas os contedores de PostgreSQL de de Adminer, pero a base de datos permanece gardada no volume e na súa última versión (co novo albergue incluído). Pero se eliminas o volume, eliminas consigo a base de datos e polo tanto ao iniciar de novo os servizos definidos no compose créase de novo a táboa seguindo as instruccións de initdb/. 
