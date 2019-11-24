FROM lambci/lambda:build-nodejs12.x as builder

WORKDIR /root

RUN npm i aws-sdk && \
zip -9yr layer.zip . && \
node -e "console.log(require('./package-lock.json').dependencies['aws-sdk'].version)" > VERSION
