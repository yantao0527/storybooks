FROM node:14-slim

WORKDIR /usr/src/app

COPY ./package*.json ./

RUN npm set registry https://registry.npm.taobao.org/ && npm install

COPY . .

USER node

EXPOSE 3000

CMD ["npm", "start"]