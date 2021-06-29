for f in *.jsonnet
do 
  jsonnet -y $f | yq eval -P > ./results/$f
  mv -- "./results/$f" "./results/${f%.jsonnet}.yml"
done
