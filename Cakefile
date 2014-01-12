{spawn} = require 'child_process'

task 'build', "Build library", ->
	switch process.platform
		when 'win32', 'win64'
			cofpath =  process.env['USERPROFILE'] + '\\AppData\\Roaming\\npm\\coffee.cmd'
		else
			cofpath = 'coffee'
	
	coffee = spawn cofpath, ['-cb', '-o', './lib', './src']
	coffee.stderr.on 'data', (data) -> console.log data.toString()
	coffee.stdout.on 'data', (data) -> console.log data.toString()