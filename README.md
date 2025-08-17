A modification of OneTrainer's [NVIDIA-UI Docker Image](https://github.com/Nerogar/OneTrainer/blob/daae18eaed8c0fa39289b2ff79cc2c1e08577fcb/resources/docker/NVIDIA-UI.Dockerfile) which leverages [KasmVNC](https://kasmweb.com/kasmvnc) to display the GUI through your browser.

Now it's possible to run OneTrainer UI over the cloud!

## Steps
* `git clone https://github.com/Ethorbit/onetrainer-docker-webui`
* `cd onetrainer-docker-webui`
* `mkdir workspace`
* `mkdir OneTrainer`
* `git clone https://github.com/Nerogar/OneTrainer.git ./OneTrainer`
* `cd OneTrainer`
* `git reset --hard daae18eaed8c0fa39289b2ff79cc2c1e08577fcb`
* `cd ..`
* `docker compose up --build -d`
* Connect to https://machine-ip:6901/
* Enter `kasm_user` as the username and `onetrainer` as the password
* OneTrainer should appear
