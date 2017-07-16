const cli = require('../src/cli');
const deploy = require('../src/deploy');
const envcnf = require('envcnf');
const td = require('testdouble');

describe('command-line', () => {

	describe('deployment', () => {

		it('should be able to get namespace from env', () => {

			td.replace(deploy, 'deploy');

			td.replace(envcnf, 'env');
			td.when(envcnf.env()).thenReturn({
				'DEPLOL_NAMESPACE': 'mynamespazzze'
			});

			cli.command([ 'deploy' ]);
			td.verify(deploy.deploy({ namespace: 'mynamespazzze' }));

			td.reset();

		});

		it('should override namespace from env with namespace args', () => {

			td.replace(deploy, 'deploy');

			td.replace(envcnf, 'env');
			td.when(envcnf.env()).thenReturn({
				'DEPLOL_NAMESPACE': 'mynamespazzze'
			});

			cli.command([ 'deploy', '-n', 'anothernamespazzze' ]);
			td.verify(deploy.deploy({ namespace: 'anothernamespazzze' }));

			td.reset();

		});

		it('should be able to get tag from env', () => {

			td.replace(deploy, 'deploy');

			td.replace(envcnf, 'env');
			td.when(envcnf.env()).thenReturn({
				'DEPLOL_NAMESPACE': 'mynamespazzze',
				'DEPLOL_TAG': 'mytagg'
			});

			cli.command([ 'deploy' ]);
			td.verify(deploy.deploy({
				namespace: 'mynamespazzze',
				tag: 'mytagg'
			}));

			td.reset();

		});

		it('should override tag from env with tag args', () => {

			td.replace(deploy, 'deploy');

			td.replace(envcnf, 'env');
			td.when(envcnf.env()).thenReturn({
				'DEPLOL_NAMESPACE': 'mynamespazzze',
				'DEPLOL_TAG': 'mytagg'
			});

			cli.command(['deploy', '-t', 'anothertagg' ]);
			td.verify(deploy.deploy({
				namespace: 'mynamespazzze',
				tag: 'anothertagg'
			}));

			td.reset();

		});

	});
	
});
