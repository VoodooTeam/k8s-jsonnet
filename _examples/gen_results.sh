for f in *.jsonnet
do 
  jsonnet -y $f | yq eval -P > ./results/$f
done
