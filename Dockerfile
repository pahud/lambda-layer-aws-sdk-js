FROM lambci/lambda:build-nodejs12.x as builder

WORKDIR /root/nodejs

RUN npm i aws-sdk && \
node -e "console.log(require('./package-lock.json').dependencies['aws-sdk'].version)" > /root/VERSION && \
cd ../ && zip -9yr /root/layer.zip . 