FROM lambci/lambda:build-nodejs12.x as builder

WORKDIR /root

RUN npm i aws-sdk && \
zip -9yr layer.zip . && \
node -e "console.log(require('./package-lock.json').dependencies['aws-sdk'].version)" > VERSION


# FROM pahud/aws-sam-cli:latest as sam

# WORKDIR /home/samcli

# ENV S3BUCKET pahud-tmp-us-east-1

# COPY --from=builder /root/layer.zip $WORKDIR
# COPY --from=builder /root/VERSION $WORKDIR
# COPY sam-layer.yaml $WORKDIR
# COPY README.md $WORKDIR
# COPY LICENSE $WORKDIR

# RUN ls


# # RUN touch config.json
# RUN sam package --template-file sam-layer.yaml --s3-bucket $S3BUCKET --output-template-file sam-layer-packaged.yaml
