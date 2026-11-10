/**
 * versionn
 *
 * @copyright (C) 2014- commenthol
 * @license MIT
 */

'use strict'

const fs = require('fs')
const path = require('path')
const asyncc = require('asyncc')
const semver = require('semver')

// version pattern in files
const VERSION = /(\bVERSION\b.*?)(\d+\.\d+\.\d+(?:-[a-zA-Z0-9]+)?)/
// allowed semver inc commands
const CMDS = ['premajor', 'preminor', 'prepatch', 'prerelease', 'major', 'minor', 'patch', 'pre', 'same', 'set']

/**
 * @constructor
 * @param {Path} file
 * @param {Object} [options]
 * @param {String} options.version
 * @param {String} options.cmd
 */
function Version (file, options) {
  if (!(this instanceof Version)) {
    return new Version(file, options)
  }
  this.file = file
  this.options = options || {}
  this.version = this.options.version
  this.cmd = this.options.cmd || 'same'
  this.data = null

  if (path.basename(this.file) === 'VERSION') {
    this.options.type = 'VERSION'
  }
}

Version.CMDS = CMDS

/**
 * read and extract version
 * @param {Function} cb - callback `function({Error} err, {String} version)`
 */
Version.prototype.extract = function (cb) {
  this.readFile(function (err, data) {
    err = err || this._extract(data)
    cb && cb(err, this.version)
  }.bind(this))
}

/**
 * extract version information
 * @private
 * @param {String|Object} data - file content data
 */
Version.prototype._extract = function (data) {
  let ver
  let t

  if (typeof data === 'object') {
    ver = data.version
  } else if (this.options.type === 'VERSION') {
    ver = data.trim()
  } else {
    t = VERSION.exec(data)
    if (t && t.length === 3) {
      ver = t[2]
    }
  }
  return this.setVersion(ver)
}

/**
 * set a new version
 * @param {String} version - needs to be a semver version number
 * @return {Error} - if version is invalid return error
 */
Version.prototype.setVersion = function (version) {
  if (semver.valid(version)) {
    this.version = version
  } else {
    this.version = undefined
    return new Error('Bad semver version: ' + version)
  }
}

/**
 * increment version with semver
 * @param {String} cmd - a valid semver command
 * @return {String} - incremented version string or `undefined`
 */
Version.prototype.inc = function (cmd) {
  const sv = semver.parse(this.version, true)

  cmd = cmd || this.cmd

  if (sv && cmd && ~Version.CMDS.indexOf(cmd)) {
    if (cmd !== 'same') {
      sv.inc(cmd) // throws!!
    }
    this.version = sv.toString()
    return this.version
  }
}

/**
 * change multiple files version
 * @param {Array} files
 * @param {String} version
 * @param {Function} cb - callback(err) - {Array} err - array of errors
 */
Version.changeFiles = function (files, version, cb) {
  const err = []

  if (version === undefined) {
    return cb(new Error('version is undefined'))
  }

  asyncc.eachLimit(5, files,
    function (file, _cb) {
      const v = new Version(file, { version })
      v.change(function (_err) {
        if (_err) {
          err.push(file)
        }
        _cb()
      })
    }, function () {
      cb(err)
    }
  )
}

/**
 * change version
 * @param {Function} cb - callback `function({Error} err)`
 */
Version.prototype.change = function (cb) {
  this.readFile(function (err, data) {
    if (err) {
      cb(err)
      return
    }
    data = this._change(data)
    this.writeFile(data, cb)
  }.bind(this))
}

/**
 * change version information
 * @private
 * @param {String|Object} data
 */
Version.prototype._change = function (data) {
  if (typeof data === 'object') {
    if (data.version) {
      data.version = this.version
    }
  } else if (this.options.type === 'VERSION') {
    data = this.version
  } else {
    data = data.replace(VERSION, '$1' + this.version)
  }
  return data
}

/**
 * read file
 * @param {Function} cb - callback `function({Error} err, {String|Object} data)`
 */
Version.prototype.readFile = function (cb) {
  fs.readFile(this.file, function (err, data) {
    if (err) {
      cb && cb(err)
    } else {
      data = data.toString()
      if (path.extname(this.file) === '.json') {
        try {
          data = JSON.parse(data)
        } catch (e) {
          cb && cb(e)
          return
        }
      }
      cb && cb(null, data)
    }
  }.bind(this))
}

/**
 * write file back
 * @param {String|Object} data - data to write
 * @param {Function} cb - callback `function({Error} err)`
 */
Version.prototype.writeFile = function (data, cb) {
  if (typeof data === 'object') {
    data = JSON.stringify(data, null, 2)
    data += '\n'
  }
  fs.writeFile(this.file, data, cb)
}

module.exports = Version
