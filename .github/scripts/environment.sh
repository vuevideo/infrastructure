BRANCH_NAME=$1

BRANCH_PREFIX=`echo $BRANCH_NAME | cut -d/ -f1`

if [[ $BRANCH_PREFIX == "feature"  ]]
then
        echo "dev"
else
        echo "release"
fi