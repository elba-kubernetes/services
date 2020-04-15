git clone git@github.com:elba-kubernetes/experiment.git
sudo docker build -t wisebenchmark/queue:v1.0 -t wisebenchmark/queue:latest .
yes | rm -r experiment
