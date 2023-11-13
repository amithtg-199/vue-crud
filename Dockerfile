FROM node:15.6.0 as build-stage
RUN mkdir -p /home/node/app/node_modules

WORKDIR /home/node/app

COPY package*.json ./

RUN npm install
COPY . .
RUN npm run load-template simple-crud
RUN npm run build

FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /home/node/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
