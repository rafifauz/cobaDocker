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

### 2. Build container dari Docker image

Jalankan command berikut untuk membuat dan menjalankan container dari Image yang ada di Docker

```
docker run -it -d --name container_name -p external_port:internal_port your_image_name:your_image_tag
```
Contoh:
```
docker run -it -d --name laravel-web -p 8080:80 web_laravel:v1
```

### 3. Mengakses teminal milik container

Jalankan command berikut untuk mengakses terminal di dalam Container yg sudah di buat

```
docker exec -it container_id sh
```

