# install QEMU
# docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

gradle shadowjar
 docker build -t myapp-native . --debug

#docker run  -t myapp-native



# Extract variables for region and profile
REGION=ap-northeast-1
PROFILE=private
ACCOUNT_ID=338481711832

# Create the repository
aws --profile $PROFILE \
 ecr create-repository --repository-name myapp-native --region $REGION

echo "aaaa1"

# Login to the Docker repository
aws --profile $PROFILE \
 ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

echo "aaaa2"

docker tag myapp-native:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/myapp-native:latest

echo "aaaa3"

docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/myapp-native:latest


echo "aaaa4"



#github-label-controller-kotlin-api-gateway
#ANY /github-label-controller-kotlin → github-label-controller-kotlin (Lambda)
#
#
#デフォルトのエンドポイント
#有効
#https://2svazprdyk.execute-api.ap-northeast-1.amazonaws.com/github-label-controller-kotlin