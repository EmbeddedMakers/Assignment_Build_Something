# Apply only the parts matching the label for the configmap and the textStore
kubectl apply -f translatorApp-v1-0.yaml -l data=config
kubectl apply -f translatorApp-v1-0.yaml -l app=libretranslate-redis

# Extract the clusterIP
export redis_host=$( kubectl get services/libretranslate-redis-svc --template='{{.spec.clusterIP}}' )

# Retrieve the ConfigMap, replace "NOTSET" with the clusterIP, and re-apply.
kubectl get configmap/libretranslate-config -o yaml | sed -r "s/NOTSET/$redis_host/" | kubectl apply -f -

# Finally, start the qfapp
kubectl apply -f translatorApp-v1-0.yaml -l app=libretranslate