const deplol = require('../index');
const envcnf = require('envcnf');
const td = require('testdouble');

describe('Deplol', () => {

	describe('command-line', () => {

		describe('deployment', () => {

			it('should be able to get namespace from env', () => {

				td.replace(deplol, 'deploy');

				td.replace(envcnf, 'env');
				td.when(envcnf.env()).thenReturn({
					'DEPLOL_NAMESPACE': 'mynamespazzze'
				});

				deploy.cli('deploy');
				td.verify(deploy({ namespace: 'mynamespazzze' }));

				td.reset();

			});

			it('should override namespace from env with namespace args', () => {

				td.replace(deplol, 'deploy');

				td.replace(envcnf, 'env');
				td.when(envcnf.env()).thenReturn({
					'DEPLOL_NAMESPACE': 'mynamespazzze'
				});

				deploy.cli('deploy -n anothernamespazzze');
				td.verify(deploy({ namespace: 'anothernamespazzze' }));

				td.reset();

			});

			it('should be able to get tag from env', () => {

				td.replace(deplol, 'deploy');

				td.replace(envcnf, 'env');
				td.when(envcnf.env()).thenReturn({
					'DEPLOL_NAMESPACE': 'mynamespazzze',
					'DEPLOL_TAG': 'mytagg'
				});

				deploy.cli('deploy');
				td.verify(deploy({ namespace: 'mynamespazzze', tag: 'mytagg' }));

				td.reset();

			});

			it('should override tag from env with tag args', () => {

				td.replace(deplol, 'deploy');

				td.replace(envcnf, 'env');
				td.when(envcnf.env()).thenReturn({
					'DEPLOL_NAMESPACE': 'mynamespazzze',
					'DEPLOL_TAG': 'mytagg'
				});

				deploy.cli('deploy -t anothertagg');
				td.verify(deploy({
					namespace: 'anothernamespazzze',
					tag: 'anothertagg'
				}));

				td.reset();

			});

		});
		
	});

});
