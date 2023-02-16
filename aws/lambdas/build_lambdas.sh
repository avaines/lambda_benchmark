#!/bin/bash

function show_help {
    echo "Build a Python lambda layer"
    echo " "
    echo "Script [options] [arguments]"
    echo " "
    echo "options:"
    echo "-h              Shows this brief help output"
    echo "-b bucket_arn   [required] ARN for target S3 bucket"
    echo "-v              [optional] Enables Verbose output"
    exit 0
}

# Default values for optional params
VERBOSE=false
BUILD_POSTFIX="_dev"
BUILD_TYPE="Dev"
BUILD_VERSION=""
BUCKET_ARN=""
BUCKET_NAME=""

while getopts "hvb:" opt; do
  case ${opt} in
    h | \? )
        show_help
        ;;
    : )
        echo "Invalid Option: -$OPTARG requires an argument" 1>&2
        show_help
        ;;
    b )
        BUCKET_ARN=$OPTARG
        BUCKET_NAME=$(echo $BUCKET_ARN | rev | cut -d ":" -f 1 | rev)
        ;;
    v )
        # Enables verbose/debug output
        VERBOSE=true
        ;;
  esac
done
shift $((OPTIND -1))

set -eu
if ${VERBOSE}; then
    set -x
fi

# Loop through all the lambda directories
for directory in *; do
    # Check this actually is a directory, and not a file.
    if [ -d "${directory}" ]; then
        # echo "This is ${directory}"
        echo "Starting to build ${BUILD_TYPE} version of \"${directory}\""
        archive_name="${directory}"

        # Drop in to the lambda directory, and delete the archive if one is already present
        pushd "${directory}" > /dev/null
        [[ -f "${archive_name}.zip" ]] && rm "${archive_name}.zip"

        # Check for presence of a custom build script, if there isn't, just zip the contents of the folder up.
        if [[ -f "custom-build.sh" ]]; then
            echo "Custom to build script found in ${directory}, running"
            bash custom-build.sh "${archive_name}"
        else
            echo "No custom build script found in ${directory}, packackaging directory"
            zip -r "${archive_name}.zip" *
        fi

        # If we are supposed to be uploading this to an S3 bucket, do so
        if [[ -n "${BUCKET_ARN}" ]]; then
            aws s3 cp ${archive_name}.zip s3://${BUCKET_NAME}/lambda/ \
                --metadata Env=${BUILD_TYPE},Function=${directory},Hash=$(openssl dgst -binary -sha256 ${archive_name}.zip | openssl base64)
            rm ${archive_name}.zip
        fi

        popd > /dev/null
        echo ''
    fi
done
