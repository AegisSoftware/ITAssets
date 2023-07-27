# Pull
echo Updating Repo
cd ~/Documents/GitHub/Vuetfy-Server-Project/
git fetch origin
git reset --hard origin/master
git pull
# Clear Old
echo Clearing Old Images
cd ~/Documents/GitHub/Vuetfy-Server-Project/builders
rm ./*.tar
# Backend
echo Building Backend
cd ~/Documents/GitHub/Vuetfy-Server-Project/builders/backend
cp ~/Documents/GitHub/Vuetfy-Server-Project/Backend-main/src/package.json .
docker build -t backend .
docker image save -o backend.tar backend:latest
mv ./backend.tar ..
rm ./package.json
# Frontend
echo Building Frontend
cd ~/Documents/GitHub/Vuetfy-Server-Project/builders/frontend
docker build -t frontend .
docker image save -o frontend.tar frontend:latest
mv ./frontend.tar ..
# Deploy
echo Deploying...
cd ~/Documents/GitHub/Vuetfy-Server-Project/builders
ssh jared@4.246.161.216 "rm /tmp/*.tar"
scp ./backend.tar jared@4.246.161.216:/tmp
scp ./frontend.tar jared@4.246.161.216:/tmp
echo Deploying Backend...
ssh jared@4.246.161.216 "docker rm backend_ctr --force ; docker image rm backend ; docker load -i /tmp/backend.tar ; docker run -d -p 3000:3000 --name backend_ctr backend:latest"
echo Deploying Frontend...
ssh jared@4.246.161.216 "docker rm frontend_ctr --force ; docker image rm frontend ; docker load -i /tmp/frontend.tar ; docker run -d -p 80:80 --name frontend_ctr frontend:latest"
echo DONE!