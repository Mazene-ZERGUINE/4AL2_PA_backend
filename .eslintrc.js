module.exports = {
	root: true,
	parser: '@typescript-eslint/parser',
	parserOptions: {
		project: 'tsconfig.json',
		tsconfigRootDir: __dirname,
		sourceType: 'module',
	},
	plugins: ['@typescript-eslint/eslint-plugin', 'unused-imports', 'jest'],
	extends: [
		'plugin:@typescript-eslint/recommended',
		'eslint:recommended',
		'plugin:jest/recommended',
		'plugin:jest/style',
		'prettier',
		'plugin:prettier/recommended',
	],
	overrides: [
		{
			files: ['test/**'],
			plugins: ['jest'],
			extends: ['plugin:jest/recommended', 'plugin:jest/style'],
			rules: { 'jest/prefer-expect-assertions': 'off' },
		},
	],
	env: {
		node: true,
		jest: true,
		'jest/globals': true,
	},
	ignorePatterns: ['.eslintrc.js'],
	rules: {
		"indent": ["error", "tab"],
		"prettier/prettier": [2, { "useTabs": true }],
		'@typescript-eslint/interface-name-prefix': 'off',
		'@typescript-eslint/explicit-function-return-type': 'warn',
		'@typescript-eslint/explicit-module-boundary-types': 'warn',
		'@typescript-eslint/no-explicit-any': 'off',

		semi: ['error', 'always'],
		'no-console': 'warn',
		'no-unused-vars': ['error', { args: 'none' }],
		'unused-imports/no-unused-imports': 'error',
		'unused-imports/no-unused-vars': [
			'warn',
			{
				vars: 'all',
				varsIgnorePattern: '^_',
				args: 'after-used',
				argsIgnorePattern: '^_',
			},
		],
		'@typescript-eslint/naming-convention': [
			'error',
			{ selector: 'variable', format: ['camelCase', 'UPPER_CASE'] },
			{ selector: 'function', format: ['camelCase'] },
			{ selector: 'interface', format: ['PascalCase'] },
		],
		'@typescript-eslint/no-unused-vars': [
			'error',
			{
				vars: 'all',
				args: 'after-used',
				ignoreRestSiblings: false,
			},
		],

		'jest/no-disabled-tests': 'warn',
		'jest/no-focused-tests': 'error',
		'jest/no-identical-title': 'error',
		'jest/prefer-to-have-length': 'warn',
		'jest/valid-expect': 'error',
	},
};
