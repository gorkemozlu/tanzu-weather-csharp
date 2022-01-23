load('.tanzu/tanzu_tilt_extensions.py', 'tanzu_k8s_yaml')


SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='harbor.dorn.gorke.ml/tap/tanzu-weather-source')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='dev')
local_resource(
      'build',
      'dotnet publish src --configuration Release --runtime ubuntu.18.04-x64 --self-contained false --output ./build',
      deps=['src'],
      ignore=['src/bin','src/obj']
)

custom_build('harbor.dorn.gorke.ml/tap/tanzu-weather',
    "tanzu apps workload apply -f config/workload.yaml --live-update" +
    " --namespace " + NAMESPACE +
    " --local-path " + LOCAL_PATH + " --source-image " + SOURCE_IMAGE + " --yes && \
    .tanzu/wait.sh tanzu-weather",
  ['./build'],
  live_update = [ 
    sync('./build', '/workspace/build'),
    run('cp -rf /workspace/build/* /workspace', trigger='./build')
  ],
  skips_local_docker=True
  
)
allow_k8s_contexts('gke_gorkemozlu_europe-central2-c_tap-gke02')
tanzu_k8s_yaml('tanzu-weather', 'harbor.dorn.gorke.ml/tap/tanzu-weather', './config/workload.yaml')
