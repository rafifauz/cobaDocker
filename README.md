# cobaDocker
Mebuat docker image secara custom dan menjalankan image tersebut dalam container

### 1. Build image dari Dockerfile

Jalankan command berikut untuk mebuat Image di Docker

```
docker build -t your_image_name:your_image_tag .
```
Contoh:
```
docker build -t web_laravel:v1 .
```

### 2. Build image dari Dockerfile

Jalankan command berikut untuk membuat dan manjelankan container dari Image yang ada di Docker

```
docker run -it -d --name container_name -p external_port:internal_port your_image_name:your_image_tag
```
Contoh:
```
docker run -it -d --name laravel-web -p 8080:80 web_laravel:v1
```
