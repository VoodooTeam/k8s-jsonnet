.PHONY: compare
compare:
	jsonnet -e "(import './dev/_main.libsonnet').output.${svc}" | jd ./golden-${svc}.json
