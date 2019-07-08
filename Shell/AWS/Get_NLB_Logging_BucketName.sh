outputfilename=AWSNetWorkLBS3Bucket.xls
echo "" > $outputfilename
for loadbalancerarn in $(aws elbv2 describe-load-balancers --profile hooq --region ap-southeast-1 --output text --query 'LoadBalancers[?Type==`network`].LoadBalancerArn');
do
s3enabled=$(aws elbv2 describe-load-balancer-attributes --load-balancer-arn $loadbalancerarn --profile hooq --output text --query 'Attributes[?Key==`access_logs.s3.enabled`].Value')

if [ $s3enabled = true ]
then
	bucketname=$(aws elbv2 describe-load-balancer-attributes --load-balancer-arn $loadbalancerarn --profile hooq --output text --query 'Attributes[?Key==`access_logs.s3.bucket`].Value')

	echo "$loadbalancerarn","$s3enabled","$bucketname" >>	$outputfilename
else
	echo "$loadbalancerarn","$s3enabled" >>	$outputfilename
fi
done