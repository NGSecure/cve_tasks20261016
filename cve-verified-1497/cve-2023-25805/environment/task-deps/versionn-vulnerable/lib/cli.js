/**
 * versionn CLI
 *
 * @copyright (C) 2014- commenthol
 * @license MIT
 *
 * @credits Christopher Jeffrey <https://github.com/chjj/marked>
 *   Code snippets taken from marked project (MIT license)
 */

'use strict'

function getarg (argv) {
  let arg = argv.shift()

  if (arg === undefined) {
    return
  }

  if (arg.indexOf('--') === 0) {
    // e.g. --opt
    arg = arg.split('=')
    if (arg.length > 1) {
      // e.g. --opt=val
      argv.unshift(arg.slice(1).join('='))
    }
    arg = arg[0]
  } else if (arg[0] === '-') {
    if (arg.length > 2) {
      // e.g. -abc
      argv = arg.substring(1).split('').map(function (ch) {
        return '-' + ch
      }).concat(argv)
      arg = argv.shift()
    } else {
      // e.g. -a
    }
  } else {
    // e.g. foo
  }

  return arg
}

/**
 * @param {Array} argv - commandline arguments
 * @param {Array} cmds - allowed commands
 */
function cli (argv, cmds) {
  let arg
  const opts = {
    files: []
  }
  if (!argv) {
    argv = process.argv.splice(2)
  }
  cmds = cmds || []

  while (argv.length) {
    arg = getarg(argv)
    switch (arg) {
      case '-h':
      case '--help': {
        opts.help = true
        return opts
      }
      case '-i':
      case '--info': {
        opts.info = true
        break
      }
      case '-d':
      case '--dir': {
        arg = getarg(argv)
        opts.dir = arg
        break
      }
      case '-e':
      case '--extract': {
        arg = getarg(argv)
        opts.extract = arg || true
        break
      }
      case '-t':
      case '--tag': {
        opts.tag = true
        break
      }
      case '-u':
      case '--untag': {
        opts.untag = true
        break
      }
      case '-c':
      case '--commit': {
        opts.commit = true
        break
      }
      case '-V':
      case '--version': {
        opts.cliVersion = true
        return opts
      }
      default: {
        if (arg.indexOf('-') === 0) { // maintain for backwards compatibility
          arg = arg.replace(/^-+/, '')
          if (!~cmds.indexOf(arg)) {
            continue
          }
          opts.cmd = arg
          if (arg === 'set') {
            opts.cmdVersion = getarg(argv)
          }
        } else if (~cmds.indexOf(arg)) {
          opts.cmd = arg
          if (arg === 'set') {
            opts.version = getarg(argv)
          }
        } else {
          opts.files.push(arg)
        }
        break
      }
    }
  }

  return opts
}

module.exports = cli
