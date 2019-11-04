# Examples

First, make sure you create the JSON file to be serve by server. See [JSON database example here](database.json).
Then you can start server by following commands.

To start a default server, which binds to `127.0.0.1:1711`, using `database.json`.

```
$ jserver -d database.json
$ jserver --data database.json
```

To start server at `localhost:8888` using `api.json` for database.

```
$ jserver -h localhost -p 8888 -d api.json
```

Alternatively, you can use:

```
$ jserver --host localhost --port 8888 -d api.json
```