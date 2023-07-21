# NOTE

This is a opinionated fork of the original repo meant for easy local labeling. Do not use this as a public service under any circumstance.

# brat docker

This is a docker container deploying an instance of [brat](http://brat.nlplab.org/).

### Installation

Change the bind mapping of the docker-compose to your data directory

```yml
volumes:
  - "../data_preparation/out:/bratdata"
```

users.json is ready and prefilled with:

```javascript
{
    "local": "local",
    ...
}
```

### Running

```bash
$ docker compose up -d
```
