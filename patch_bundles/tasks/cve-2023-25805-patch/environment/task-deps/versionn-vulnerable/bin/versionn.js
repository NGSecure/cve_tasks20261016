#!/usr/bin/env node

/**
 * versionn CLI
 *
 * @copyright (C) 2014- commenthol
 * @license MIT
 */

'use strict'

var VERSION = '1.0.3'

var fs = require('fs')
var path = require('path')
var asyncc = require('asyncc')
var child = require('child_process')
var Version = require('../lib/index')
var cli = Version._.cli
var GitFn = Version._.GitFn

function help () {
  var options = {
    cwd: process.cwd(),
    env: process.env,
    setsid: false,
    stdio: [0, 1, 2]
  }

  child.spawn('man',
    [path.resolve(__dirname, '../man/versionn.1')],
    options
  )
}

function main (argv, callback) {
  var options = cli(argv, Version.CMDS)

  if (options.help) {
    help()
    return
  } else if (options.cliVersion) {
    console.log('versionn v' + VERSION)
    return
  }

  if (options.files.length === 0) {
    options.files = main.files
    options.defaultFiles = true
  }
  options.dir = options.dir || process.cwd()
  options.files = options.files.map(function (file) {
    return path.resolve(options.dir, file)
  })

  // console.log(options)
  var v

  asyncc.series([
    // check if files exists
    function (cb) {
      asyncc.each(options.files, (file, cb) => fs.stat(file, cb), function (err, files) {
        err = null
        files = options.files.map(function (file, i) {
          if (files[i]) {
            return options.files[i]
          } else {
            if (!options.defaultFiles) {
              console.error('error: File not found: ' + options.files[i])
            }
          }
        })
          .filter(function (file) {
            return file
          })

        if (files.length > 0) {
          options.extract = options.extract
            ? path.resolve(options.dir, options.extract)
            : files[0]
          options.files = files
        } else {
          err = new Error('No files found in ' + options.dir)
        }
        cb(err)
      })
    },
    // does file to extract exist
    function (cb) {
      fs.stat(options.extract, function (err) {
        if (err) {
          err = new Error('No file to extract version from: ' + options.extract)
        }
        cb(err)
      })
    },
    // extract version info
    function (cb) {
      v = new Version(options.extract)
      v.extract(cb)
    },
    // show version info
    function (cb) {
      var err
      if (options.info) {
        console.log(v.version)
        err = new Error('') // exit
      }
      cb(err)
    },
    // set command
    function (cb) {
      var err
      if (options.cmd === 'set') {
        options.cmd = 'same'
        err = v.setVersion(options.version)
      }
      cb(err)
    },
    // change files
    function (cb) {
      if (!(options.extract === true && options.cmd === undefined)) {
        v.inc(options.cmd)
      }
      Version.changeFiles(options.files, v.version, function (err) {
        if (err && err.length > 0) {
          err = err.map(function (f) {
            return 'Version not set in ' + f
          }).join('\n')
          cb(err)
        } else {
          console.log(v.version)
          cb()
        }
      })
    },
    // git commit
    function (cb) {
      if (options.commit) {
        new GitFn(v.version, options).commit(cb)
      } else {
        cb()
      }
    },
    // git tag or untag
    function (cb) {
      if (options.tag) {
        new GitFn(v.version, options).tag(cb)
      } else if (options.untag) {
        new GitFn(v.version, options).untag(cb)
      } else {
        cb()
      }
    }],
  callback
  )
}

main.files = [ 'VERSION', 'package.json', 'bower.json', 'component.json' ]

/**
 * Expose / Entry Point
 */
if (!module.parent) {
  process.title = 'versionn'
  main(process.argv.splice(2), function (err) {
    var code = 0
    if (err && err.message) {
      code = 1
      console.error('error: ' + err.message)
    }
    return process.exit(code)
  })
} else {
  module.exports = main
}
