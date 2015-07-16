#! /bin/bash -x

set -ex

VERSION="develop-"`date '+%Y%m%d-%H%M'`

# Create new Elastic Beanstalk version
EB_BUCKET=gushry-docker-play2-dev
DOCKERRUN_FILE=./Dockerrun.aws.json
aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE
aws elasticbeanstalk create-application-version --application-name docker-play \
  --version-label $VERSION S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name dev-docker-play2 \
    --version-label $VERSION

