.PHONY: test
test:
	bats -r .
	cd ./_examples && ./gen_results.sh
