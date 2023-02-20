exports.handler = async (event) => {
    console.log('Lambda Benchmark');
    return event.toUpperCase();
};
