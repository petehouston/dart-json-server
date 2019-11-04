# JSON Server

Launch JSON server for web and mobile apps development from CLI without complicated backend setup.

## Usage

```
jserver --data=<path to JSON file>
```

Available options you can use:

* `-d, --data`: path to JSON database file. **Required**.
* `-h, --host`: specify the IP address to serve. Default to `127.0.0.1`.
* `-p, --port`: specify the port to use. Default to `1711`.

### JSON Format

Typically, for JSON database, you need to use following structure.

```json
{
  "API_PATH_1": RESPONSE_OBJECT_1,
  "API_PATH_2": RESPONSE_OBJECT_2,
}
```

**API_PATH** must start with a slash `/` to mark it as a serving path for API.
**RESPONSE_OBJECT**: should be either `Array` or `Object`.


### Examples

To start a default server, which binds to `127.0.0.1:1711`, using `database.json`.

```
$ jserver -d database.json
```

To start server at `localhost:8888` using `api.json` for database.

```
$ jserver -h localhost -p 8888 -d api.json
```

# LICENSE

MIT @ 2019 by [Pete Houston](https://petehouston.com). 