#! /bin/bash -x

set -ex

VERSION="develop-"`date '+%Y%m%d-%H%M'`

# Create new Elastic Beanstalk version
EB_BUCKET=gushry-docker-play2-dev
DOCKERRUN_FILE=Dockerrun.aws.json

ZIPFILE=deploy.zip
if [ -f $ZIPFILE ]; then
  rm $ZIPFILE
fi
zip $ZIPFILE $DOCKERRUN_FILE .ebextensions

aws --version
aws configure set aws_access_key_id $AWSKEY
aws configure set aws_secret_access_key $AWSSECRETKEY
aws configure set default.region ap-northeast-1
aws configure set default.output json

#aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE
#aws s3 sync . s3://$EB_BUCKET/ --exclude README.md --exclude circle.yml --exclude .git --exclude venv
aws s3 cp $ZIPFILE s3://$EB_BUCKET/
aws s3 ls s3://$EB_BUCKET

aws elasticbeanstalk create-application-version \
  --application-name docker-play \
  --version-label $VERSION \
  --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIPFILE

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name dev-docker-play2 \
  --version-label $VERSION

if [ -f $ZIPFILE ]; then
  rm $ZIPFILE
fi
