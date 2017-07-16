const deploy = require('./deploy');
const envcnf = require('envcnf');
const omitBy = require('lodash.omitby');
const parseArgs = require('minimist');

function command(cmd) {
	const argv = parseArgs(
		cmd,
		{
			string: [ 'namespace', 'tag' ],
			boolean: [ 'verbose' ],
			alias: {
				'n': 'namespace',
				't': 'tag',
				'v': 'verbose'
			},
			unknown: arg => {
				if (['publish', 'deploy'].indexOf(arg) === -1) {
					throw new Error('Unknown argument: ' + arg);
				}
			}
		}
	);

	const namespace =
		typeof argv.namespace !== 'undefined'
		? argv.namespace
		: envcnf.get('DEPLOL_NAMESPACE');

	const tag =
		typeof argv.tag !== 'undefined'
		? argv.tag
		: envcnf.get('DEPLOL_TAG');

	deploy.deploy(
		omitBy(
			{
				namespace, tag
			},
			val => typeof val === 'undefined'
		)
	);

}

module.exports = {
	command
};
