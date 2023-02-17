import boto3
import json
import csv
import argparse
from datetime import datetime
import time

lambda_arns = [
  "arn:aws:lambda:us-east-1:804221019544:function:node18-128",
  "arn:aws:lambda:us-east-1:804221019544:function:net7aot-128",
  "arn:aws:lambda:us-east-1:804221019544:function:python39-128",
]

cloudwatch_log_groups = [
  "/aws/lambda/node18-128",
  "/aws/lambda/net7aot-128",
  "/aws/lambda/python39-128",
]

def invoke_lambda_function(arn):
    arn_split = arn.split(":")

    client = boto3.client('lambda', region_name = arn_split[3])

    response = client.invoke(
        FunctionName = arn_split[-1],
        InvocationType='Event',
        Payload = json.dumps("hello"),
    )

    if response["StatusCode"] in [200, 202]:
        return "Success"
    else:
        return "Error"

def generate_lambda_duration_report(log_groups, start_timestamp, region):
    client = boto3.client('logs', region_name = region)

    insight_query = """
        filter @type = “REPORT”
        | stats
        count(@initDuration) as numColdStarts,
        avg(@initDuration) as avgColdStartTime,
        count(@duration) - numColdStarts as numWarmStarts,
        avg(@duration) as avgDuration,
        avg(@maxMemoryUsed) as avgMemoryUsed,
        avg(@memorySize) as avgMemoryAllocated,
        (avg(@maxMemoryUsed)/max(@memorySize))*100 as avgPercentageMemoryUsed
        by @log
    """

    response = client.start_query(
        logGroupNames = log_groups,
        startTime = start_timestamp,
        endTime = int(datetime.now().timestamp()),
        queryString=insight_query,
    )

    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
        query_id = response['queryId']
        response = None

        while response == None or response['status'] == 'Running':
            print('Waiting for query to complete ...')
            time.sleep(5)

            response = client.get_query_results(
                queryId = query_id
            )

        return response["results"]
    else:
        return "Query Failed"

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--invocations', "-i", type=int, help='Number of of times to invoke each function per cycle', default=2)
    parser.add_argument('--cycles', "-c", type=int, help='Number of times to run each cycle', default=1)
    parser.add_argument('--pause', "-p", type=int, help='Pause between cycles in minutes, AWS advise 45-60 mins between cold starts', default=1)
    parser.add_argument('--region', "-r", help='AWS Region to run the report in (lambda region extracted from arn)', default="us-east-1")

    args = parser.parse_args()
    start_time = datetime.now()

    print(f"Preparing for {args.cycles} cycles with a {args.pause} minutes pause between. Within each cycle, all functions will be called {args.invocations} times")

    for c in range(1, args.cycles):
        print(f"Running cycle {c} of {args.cycles}")
        for i in range(0, args.invocations):
            for lambda_arn in lambda_arns:
                print(f"Running {lambda_arn}: {invoke_lambda_function(lambda_arn)}")
        if (args.cycles - c) > 0:
            print(f"Pausing at {datetime.now().strftime('%H:%M:%S')} for {args.cycles} minutes")
            time.sleep(args.pause * 60)

    finshed_invoke_time = datetime.now()

    print()
    print(f"Invoking all functions took {(finshed_invoke_time - start_time).seconds} seconds to run")
    mins_for_logs_to_turn_up = 5
    print(f"Waiting {mins_for_logs_to_turn_up} minutes for all the logs to make their way to CloudWatch...")
    time.sleep(mins_for_logs_to_turn_up * 60)
    print()

    lambda_duration_report = generate_lambda_duration_report(cloudwatch_log_groups, int(start_time.timestamp()), args.region)

    with open('report.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)

        # Write the headers to the CSV file
        headers = [field['field'] for field in lambda_duration_report[0]]
        csvwriter.writerow(headers)

        # Write the data rows to the CSV file
        for row in lambda_duration_report:
            csvwriter.writerow([field['value'] for field in row])
