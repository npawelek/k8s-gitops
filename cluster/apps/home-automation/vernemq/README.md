# VerneMQ Notes

Due to lack of updates to the helm chart (https://github.com/vernemq/docker-vernemq/issues/238), deploying this proves to be difficult as there is no `initContainer` support, nor ability to change volume permissions on mismatch within `securityContext`.

In order to work around this, I had to implement the following options:

```
securityContext:
  # runAsUser: 10000
  # runAsGroup: 10000
  # fsGroup: 10000
  runAsUser: 0
  runAsGroup: 0
```

Then, as each container comes up, chown the `/vernemq/data` directory:

```
k exec -it -n home-automation vernemq-0 -- chown -R vernemq:vernemq /vernemq/data
k exec -it -n home-automation vernemq-1 -- chown -R vernemq:vernemq /vernemq/data
k exec -it -n home-automation vernemq-2 -- chown -R vernemq:vernemq /vernemq/data
k scale -n home-automation sts vernemq --replicas 0
```

... and reset the run-as configuration:

```
securityContext:
  runAsUser: 10000
  runAsGroup: 10000
  fsGroup: 10000
  # runAsUser: 0
  # runAsGroup: 0
```
