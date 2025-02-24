# Install
Вряд ли кто-то будет стараться разворачивать k8s кластер из одной ноды на своем ноутбуке, поэтому будем все выкатывать в minikube
##### Requirements for minikube
- [KVM2](https://minikube.sigs.k8s.io/docs/drivers/kvm2/) или [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads) (у меня kvm2)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) 

Также нам конечно понадобятся манифесты, скачаем их
```bash
git clone https://gitlab.com/zeroking783/tz_webant
```

После уставноки minikube нужно его запустить
```bash
minikube start
```
Он автоматически запустит кластер из одной ноды (CPUs=2, Memory=5800MB, Disk=20000MB). Теперь мы можем начинать применять скачанные манифесты.

Начнем с создания namespace, чтобы разделить это приложение от других
```bash
kubectl apply -f namespace.yml
```
Отдельным сервисом для базы данных будет выступать Helm-чарт [bitnami/postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql). Однако, прежде чем приступить к установке этого чарта, необходимо создать локальное хранилище для данных базы. Это гарантирует сохранение всех данных даже при потери пода. Для настройка хранилища нужно будет ввести следующие команды
```bash
kubectl apply -f storage-class.yml -n winter-dev
kubectl apply -f pv.yml -n winter-dev
kubectl apply -f pvc.yml -n winter-dev
```
Чтобы избежать возможных ошибок и гарантировать корректную работу хранилища, необходимо создать директорию внутри minikube, которую мы указали в качестве места хранения данных. Для этого нужно выполнить следующие команды
```bash
minikube ssh
sudo mkdir -p /mnt/minikube/kubestorage/postgresql
sudo chmod 755 -R /mnt/minikube/kubestorage/postgresql
exit
```
Можем устанавливать Helm-чарт и он развернет нам все необходимое для работы базы данных
```bash
helm install postgre oci://registry-1.docker.io/bitnamicharts/postgresql -n winter-dev -f postgre-values.yml
```
На этом этапе этапе сервис с базой данных уже должен начать свою работу, но это лишь один из сервисов. Необходимо еще применить манифест с сервисом Nginx и манифест с Winter CMS
```bash
kubectl apply -f nginx.yml -n winter-dev
kubectl apply -f winter-cms.yml -n winter-dev
```
После того как все необходимые манифесты были применены, осталось лишь дождаться, пока все компоненты запустятся. Чтобы проверить статус их работы, используйте команду
```bash
kubectl get pod -n winter-dev
```
Когда все поды будут иметь статус Running, можно будет заходить на сайт по ссылке http://minikube-ip:9000. IP адресс minikube можно узнать командой 
```bash
minikube ip
```
Для захода в админ панель нужно перейти по адрессу http://minikube-ip:9000/backend и ввести логин и пароль: admin и admin.

# Description (k8s)
В соответствии с принципами микросервисной архитектуры, компоненты приложения должны быть максимально изолированы. В данном случае Nginx запускается как отдельный сервис, независимый от Winter CMS. Это не только обеспечивает лучшую масштабируемость и управляемость, но и позволяет гибко настраивать балансировку нагрузки, кэширование и другие оптимизации на уровне веб-сервера. Всю структуру можно описать схемой: